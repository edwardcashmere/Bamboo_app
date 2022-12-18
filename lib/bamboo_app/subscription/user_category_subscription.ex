defmodule BambooApp.Subscription.UserCategorySubscription do
  @moduledoc false
  use BambooApp.CommonSchema

  @primary_key false
  schema "user_category_subscriptions" do
    belongs_to :category, BambooApp.Stocks.Category, primary_key: true
    belongs_to :user, BambooApp.Accounts.User, primary_key: true

    timestamps()
  end

  @doc """
  validate subscriptions
  """
  def changeset(user_category_subscription, attrs) do
    user_category_subscription
    |> cast(attrs, [:category_id, :user_id])
    |> validate_required([:category_id, :user_id])
    |> unique_constraint(:user_id, name: :category_user_index)
  end
end
