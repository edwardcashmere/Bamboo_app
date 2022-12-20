defmodule BambooApp.SubscriptionTest do
  @moduledoc false
  use BambooApp.DataCase, async: true

  alias BambooApp.Subscription

  describe "user_category_subscriptions" do
    alias BambooApp.Subscription.UserCategorySubscription

    @invalid_attrs %{}

    setup do
      [user_subscription: insert(:user_category_subscription)]
    end

    test "list_user_category_subscriptions/0 returns all user_category_subscriptions", %{
      user_subscription: user_subscription
    } do
      %{category_id: category_id, user_id: user_id} = user_subscription

      assert [%UserCategorySubscription{category_id: ^category_id, user_id: ^user_id}] =
               Subscription.list_user_category_subscriptions()
    end

    test "get_user_subscribers_by_category/1 returns the user_category_subscription with given id" do
      category = insert(:category)
      user_1 = %{id: user_1_id} = insert(:user, username: "john")
      user_2 = %{id: user_2_id} = insert(:user, username: "doe")
      insert(:user_category_subscription, category: category, user: user_1)
      insert(:user_category_subscription, category: category, user: user_2)

      assert [
               %UserCategorySubscription{user_id: ^user_1_id},
               %UserCategorySubscription{user_id: ^user_2_id}
             ] = Subscription.get_user_subscribers_by_category(category.id)
    end

    test "create_user_category_subscription/1 with valid data creates a user_category_subscription" do
      valid_attrs = params_with_assocs(:user_category_subscription)

      assert {:ok, %UserCategorySubscription{} = _user_category_subscription} =
               Subscription.create_user_category_subscription(valid_attrs)
    end

    test "create_user_category_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Subscription.create_user_category_subscription(@invalid_attrs)
    end

    test "delete_user_category_subscription/1 deletes the user_category_subscription", %{
      user_subscription: user_subscription
    } do
      assert {:ok, %UserCategorySubscription{}} =
               Subscription.delete_user_category_subscription(user_subscription)

      assert [] = Subscription.get_user_subscribers_by_category(user_subscription.category_id)
    end

    test "change_user_category_subscription/1 returns a user_category_subscription changeset", %{
      user_subscription: user_subscription
    } do
      assert %Ecto.Changeset{} = Subscription.change_user_category_subscription(user_subscription)
    end
  end
end
