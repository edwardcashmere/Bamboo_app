defmodule BambooApp.Repo.Migrations.CreateCompanies do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :description, :string
      add :ticker, :string
      add :price, :float
      add :category_id, references(:categories, on_delete: :nothing, null: false)

      timestamps()
    end

    create index(:companies, [:category_id])
    create unique_index(:companies, [:ticker, :name], name: :ticker_name_index)
  end
end
