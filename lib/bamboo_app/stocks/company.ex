defmodule BambooApp.Stocks.Company do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "companies" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :ticker, :string

    belongs_to :category, BambooApp.Stocks.Category

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :ticker, :price, :category_id])
    |> update_change(:name, &String.downcase/1)
    |> update_change(:ticker, &String.upcase/1)
    |> validate_required([:name, :description, :ticker, :price, :category_id])
    |> unique_constraint(:ticker, name: :ticker_name_index)
  end

  
end
