defmodule BambooApp.Repo.Migrations.CreateUserCategorySubscriptions do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:user_category_subscriptions, primary_key: false) do
      add :category_id, references(:categories, on_delete: :nothing),
        null: false,
        primary_key: true

      add :user_id, references(:users, on_delete: :nothing), null: false, primary_key: true

      timestamps()
    end

    create unique_index(:user_category_subscriptions, [:category_id, :user_id],
             name: :category_user_index
           )
  end
end
