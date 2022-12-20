defmodule BambooApp.Stocks do
  @moduledoc """
  The Stocks context.
  """

  import Ecto.Query, warn: false
  alias BambooApp.Repo

  alias BambooApp.Stocks.Category
  alias BambooApp.Workers.SubscribersWorker

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  @spec list_categories :: [Category.t()]
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises nil if the Category does not exist.

  ## Examples

      iex> get_category(123)
      %Category{}

      iex> get_category(456)
      nil

  """

  @spec get_category(id :: number()) :: Category.t() | nil
  def get_category(id), do: Repo.get(Category, id)

  @spec get_category_by_name(name :: String.t()) :: Category.t() | nil
  def get_category_by_name(name) do
    IO.inspect("I get here 3")
      Repo.get_by(Category, name: name) |> IO.inspect()
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_category(attrs :: map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_category(category :: Category.t(), attrs :: map()) ::
          {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_category(category :: Category.t()) :: {:ok, Category.t()} | {:error, Category.t()}
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  @spec change_category(category :: Category.t(), map()) :: Ecto.Changeset.t()
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias BambooApp.Stocks.Company

  @doc """
  Returns the list of companies.
  ## Examples

      iex> list_conpanies(params)
      [%Company{}, ...]

  """
  @spec list_companies(params :: map()) :: [Company.t()]
  def list_companies(params \\ %{}) do
    default_params = %{limit: 500, criteria: :all, last_seen: NaiveDateTime.utc_now()}

    {%{limit: limit, last_seen: last_seen}, criteria} =
      Map.split(Map.merge(default_params, params), [:limit, :last_seen])

    query =
      Company
      |> from(as: :company)
      |> limit(^limit)

    criteria
    |> Enum.reduce(query, fn
      {:criteria, :all}, query ->
        query

      {:criteria, :existing}, query ->
        where(query, [company: c], c.added_at <= ^last_seen)

      {:criteria, :new}, query ->
        where(query, [company: c], c.added_at > ^last_seen)

      _, query ->
        query
    end)
    |> preload(:category)
    |> Repo.all()
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_company!(id :: number()) :: Company.t() | term()
  def get_company!(id) do
    Company
    |> Repo.get!(id)
    |> Repo.preload(:category)
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_company(attrs :: map()) :: {:ok, Company.t()} | {:error, Ecto.Changeset.t()}
  def create_company(attrs \\ %{}) do
    attrs = Map.put(attrs, :added_at, NaiveDateTime.utc_now())

    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, company} ->
        company = company |> Repo.preload(:category)

        %{company_id: company.id, category_id: company.category_id}
        |> SubscribersWorker.new()
        |> Oban.insert()

        message = Jason.encode!(%{company: company})
        # broadcast message to all subriber to this category of companies
        BambooAppWeb.Endpoint.broadcast!(
          "new_companies:" <> company.category.name,
          "new_company",
          message
        )

        {:ok, company}

      # broadcast to subscribed channels
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_company(company :: Company.t(), map()) ::
          {:ok, Company.t()} | {:error, Ecto.Changeset.t()}
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_company(company :: Company.t()) ::
          {:ok, Company.t()} | {:error, Ecto.Changeset.t()}
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @spec company_added_last_24hours?() :: boolean()
  def company_added_last_24hours? do
    last_24_hours = NaiveDateTime.add(NaiveDateTime.utc_now(), -86_400)

    Company
    |> from(as: :company)
    |> where([company: c], c.added_at > ^last_24_hours)
    |> Repo.exists?()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  @spec change_company(company :: Company.t(), map()) :: Ecto.Changeset.t()
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end
end
