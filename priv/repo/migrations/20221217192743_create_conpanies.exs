defmodule BambooApp.Repo.Migrations.CreateConpanies do
  use Ecto.Migration

  def change do
    create table(:conpanies) do
      add :name, :string
      add :description, :string
      add :ticker, :string
      add :price, :float
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:conpanies, [:category_id])
  end
end
