defmodule BambooApp.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: BambooApp.Repo

  def user_factory do
    %BambooApp.Accounts.User{
      username: sequence("username"),
      email: sequence(:email, &"user-#{&1}@test.com"),
      last_seen: NaiveDateTime.utc_now()
    }
  end

  def category_factory do
    %BambooApp.Stocks.Category{
      name: sequence("category")
    }
  end

  def company_factory do
    %BambooApp.Stocks.Company{
      name: sequence("company"),
      description: sequence("The best in the world"),
      price: 10.0,
      ticker: sequence(:name, ["AMZN", "MSFT", "ABNB", "ALX", "AA"]),
      category: build(:category),
      added_at: NaiveDateTime.utc_now()
    }
  end

  def user_category_subscription_factory do
    %BambooApp.Subscription.UserCategorySubscription{
      category: build(:category),
      user: build(:user)
    }
  end
end
