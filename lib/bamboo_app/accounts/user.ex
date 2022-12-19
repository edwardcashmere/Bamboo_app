defmodule BambooApp.Accounts.User do
  @moduledoc false
  use BambooApp.CommonSchema

  schema "users" do
    field :email, :string
    field :username, :string
    field :last_seen, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :last_seen])
    |> validate_required([:email, :username, :last_seen])
    |> validate_format(:email, ~r/@/)
    |> format_string_fields(:username, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
