defmodule BambooApp.Stocks.Category do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "categories" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> downcase_username()
    |> unique_constraint(:name)
  end

  @spec downcase_username(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp downcase_username(%Ecto.Changeset{valid?: true} = changeset) do
    username = get_change(changeset, :name)

    if username do
      put_change(changeset, :name, String.downcase(username))
    else
      changeset
    end
  end

  defp downcase_username(changeset) do
    changeset
  end
end
