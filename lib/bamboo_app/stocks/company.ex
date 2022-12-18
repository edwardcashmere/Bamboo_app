defmodule BambooApp.Stocks.Company do
  @moduledoc false
  use BambooApp.CommonSchema

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
    |> format_string_fields(:name, &String.downcase/1)
    |> format_string_fields(:ticker, &String.upcase/1)
    |> validate_required([:name, :description, :ticker, :price, :category_id])
    |> unique_constraint(:ticker, name: :ticker_name_index)
  end
end
