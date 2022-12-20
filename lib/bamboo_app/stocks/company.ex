defmodule BambooApp.Stocks.Company do
  @moduledoc false
  use BambooApp.CommonSchema

  @derive {Jason.Encoder, only: [:name, :description, :price, :ticker, :category_id, :category]}
  schema "companies" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :ticker, :string

    # mainly defining this field to be used in testing
    # I need to be able to time travel to create a company
    # in the past, present and future
    field :added_at, :naive_datetime
    belongs_to :category, BambooApp.Stocks.Category

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :ticker, :price, :category_id, :added_at])
    |> format_string_fields(:name, &String.downcase/1)
    |> format_string_fields(:ticker, &String.upcase/1)
    |> validate_required([:name, :description, :ticker, :price, :category_id, :added_at])
    |> unique_constraint(:ticker, name: :ticker_name_index)
  end
end
