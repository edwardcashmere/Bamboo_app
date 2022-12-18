defmodule BambooApp.Accounts.User do
  @moduledoc false
  use BambooApp.CommonSchema

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
    |> format_string_fields(:username, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
