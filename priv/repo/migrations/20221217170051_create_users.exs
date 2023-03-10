defmodule BambooApp.Repo.Migrations.CreateUsers do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :last_seen, :naive_datetime

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
