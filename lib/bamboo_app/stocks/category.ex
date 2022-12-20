defmodule BambooApp.Stocks.Category do
  @moduledoc false
  use BambooApp.CommonSchema

  @derive {Jason.Encoder, only: [:name]}
  schema "categories" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> format_string_fields(:name, &String.downcase/1)
    |> unique_constraint(:name)
  end
end
