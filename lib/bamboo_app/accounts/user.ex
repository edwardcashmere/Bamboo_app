defmodule BambooApp.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "users" do
    field :email, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_format(:email, ~r/@/)
    |> downcase_username()
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @spec downcase_username(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp downcase_username(%Ecto.Changeset{valid?: true} = changeset) do
    username = get_change(changeset, :username)

    if username do
      put_change(changeset, :username, String.downcase(username))
    else
      changeset
    end
  end

  defp downcase_username(changeset) do
    changeset
  end
end
