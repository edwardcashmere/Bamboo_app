defmodule BambooApp.StocksTest do
  @moduledoc false
  use BambooApp.DataCase, async: true

  alias BambooApp.Stocks
  alias BambooApp.Workers.SubscribersWorker

  describe "categories" do
    alias BambooApp.Stocks.Category

    @invalid_attrs %{name: nil}

    setup do
      category = insert(:category)
      [category: category]
    end

    test "list_categories/0 returns all categories", %{category: category} do
      assert Stocks.list_categories() == [category]
    end

    test "get_category/1 returns the category with given id", %{category: category} do
      assert Stocks.get_category(category.id) == category
    end

    test "get_category_by_name/1 returns the category with given name" do
      insert(:category, name: "energy")

      assert %Category{name: "energy"} = Stocks.get_category_by_name("energy")
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: name} = params_for(:category)

      assert {:ok, %Category{name: ^name}} = Stocks.create_category(valid_attrs)
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_category(@invalid_attrs)
    end

    test "create_category/1 fails with duplicate category" do
      insert(:category, name: "transport")
      params = params_for(:category, name: "transport")

      assert {:error, %Ecto.Changeset{errors: [name: {"has already been taken", _}]}} =
               Stocks.create_category(params)
    end

    test "update_category/2 with valid data updates the category", %{category: category} do
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Stocks.update_category(category, update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset", %{category: category} do
      assert {:error, %Ecto.Changeset{}} = Stocks.update_category(category, @invalid_attrs)
      assert category == Stocks.get_category(category.id)
    end

    test "delete_category/1 deletes the category", %{category: category} do
      assert {:ok, %Category{}} = Stocks.delete_category(category)
      refute Stocks.get_category(category.id)
    end

    test "change_category/1 returns a category changeset", %{category: category} do
      assert %Ecto.Changeset{} = Stocks.change_category(category)
    end
  end

  describe "companies" do
    alias BambooApp.Stocks.Company

    setup do
      [company: insert(:company)]
    end

    @invalid_attrs %{description: nil, name: nil, price: nil, ticker: nil}

    test "list_companies/1 returns all companies", %{company: company} do
      %Company{id: id, name: name} = company

      assert [%Company{id: ^id, name: ^name}] = Stocks.list_companies()
    end

    test "list_companies/1 returns existing companies or new depending on params", %{
      company: %{id: company_1_id}
    } do
      user = insert(:user)

      %{id: company_2_id} = insert(:company, added_at: time_travel(10))
      %{id: company_3_id} = insert(:company, added_at: time_travel(15))

      existing_company_params = %{criteria: :existing, last_seen: user.last_seen}
      new_company_params = %{criteria: :new, last_seen: user.last_seen}

      # query for new companies
      assert [%Company{id: ^company_2_id}, %Company{id: ^company_3_id}] =
               Stocks.list_companies(new_company_params)

      # query for existing companies
      assert [%Company{id: ^company_1_id}] = Stocks.list_companies(existing_company_params)
    end

    test "list_companies/1 returns new companies", %{company: company} do
      %Company{id: id, name: name} = company
      assert [%Company{id: ^id, name: ^name}] = Stocks.list_companies()
    end

    test "get_company!/1 returns the company with given id", %{company: company} do
      %Company{id: id, name: name} = company

      assert %Company{id: ^id, name: ^name} = Stocks.get_company!(company.id)
    end

    test "create_company/1 with valid data creates a company and a jab is enqueued" do
      valid_attrs =
        %{
          description: description,
          name: name,
          price: price,
          ticker: ticker
        } = params_with_assocs(:company)

      assert {:ok, %Company{id: company_id, category_id: category_id} = company} =
               Stocks.create_company(valid_attrs)

      assert company.description == description
      assert company.name == name
      assert company.price == price
      assert company.ticker == ticker

      # job is enqued
      assert_enqueued(
        worker: SubscribersWorker,
        args: %{"company_id" => company_id, "category_id" => category_id}
      )
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_company(@invalid_attrs)
    end

    test "create_company/1 with duplicate name and ticker fails with error", %{company: company} do
      %{name: name, ticker: ticker} = company
      params = params_with_assocs(:company, name: name, ticker: ticker)

      assert {:error, %Ecto.Changeset{errors: [ticker: {"has already been taken", _}]}} =
               Stocks.create_company(params)
    end

    test "update_company/2 with valid data updates the company", %{company: company} do
      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        price: 456.7,
        ticker: "AMZN"
      }

      assert {:ok, %Company{} = company} = Stocks.update_company(company, update_attrs)
      assert company.description == "some updated description"
      assert company.name == "some updated name"
      assert company.price == 456.7
      assert company.ticker == "AMZN"
    end

    test "update_company/2 with invalid data returns error changeset", %{company: company} do
      assert {:error, %Ecto.Changeset{}} = Stocks.update_company(company, @invalid_attrs)
      assert company == Stocks.get_company!(company.id)
    end

    test "delete_company/1 deletes the company", %{company: company} do
      assert {:ok, %Company{}} = Stocks.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset", %{company: company} do
      assert %Ecto.Changeset{} = Stocks.change_company(company)
    end
  end

  describe "company_added_last_24hours?/0" do
    test "company_added_last_24hours?/0 returns true if atleast one company was added in in the last 24hours" do
      insert(:company, added_at: time_travel(-50_000))

      assert Stocks.company_added_last_24hours?()
    end

    test "company_added_last_24hours?/0 returns false if no company was added in in the last 24hours" do
      insert(:company, added_at: time_travel(-90_000))
      insert(:company, added_at: time_travel(-100_000))

      refute Stocks.company_added_last_24hours?()
    end
  end

  defp time_travel(time) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(time)
  end
end
