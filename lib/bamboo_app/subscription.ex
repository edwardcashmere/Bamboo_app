defmodule BambooApp.Subscription do
  @moduledoc """
  The Subscription context.
  """

  import Ecto.Query, warn: false
  alias BambooApp.Repo

  alias BambooApp.Subscription.UserCategorySubscription

  @doc """
  Returns the list of user_category_subscriptions.

  ## Examples

      iex> list_user_category_subscriptions()
      [%UserCategorySubscription{}, ...]

  """
  @spec list_user_category_subscriptions :: [UserCategorySubscription.t()]
  def list_user_category_subscriptions do
    Repo.all(UserCategorySubscription)
  end

  @doc """
  Gets a list category subscribers , otherwise empty list if subribers don't exist
  ## Examples

      iex> get_user_subscribers_by_category(123)
      [%UserCategorySubscription{}, ...]

  """
  @spec get_user_subscribers_by_category(category_id :: number()) :: [
          UserCategorySubscription.t()
        ]
  def get_user_subscribers_by_category(category_id) do
    UserCategorySubscription
    |> where(category_id: ^category_id)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Creates a user_category_subscription.

  ## Examples

      iex> create_user_category_subscription(%{field: value})
      {:ok, %UserCategorySubscription{}}

      iex> create_user_category_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_category_subscription(attrs \\ %{}) do
    %UserCategorySubscription{}
    |> UserCategorySubscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a user_category_subscription.

  ## Examples

      iex> delete_user_category_subscription(user_category_subscription)
      {:ok, %UserCategorySubscription{}}

      iex> delete_user_category_subscription(user_category_subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_category_subscription(%UserCategorySubscription{} = user_category_subscription) do
    Repo.delete(user_category_subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_category_subscription changes.

  ## Examples

      iex> change_user_category_subscription(user_category_subscription)
      %Ecto.Changeset{data: %UserCategorySubscription{}}

  """
  def change_user_category_subscription(
        %UserCategorySubscription{} = user_category_subscription,
        attrs \\ %{}
      ) do
    UserCategorySubscription.changeset(user_category_subscription, attrs)
  end
end
