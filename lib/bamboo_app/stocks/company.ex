defmodule BambooApp.Stocks.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conpanies" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :ticker, :string
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :ticker, :price])
    |> validate_required([:name, :description, :ticker, :price])
  end
end
