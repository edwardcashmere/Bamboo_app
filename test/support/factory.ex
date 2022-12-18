defmodule BambooApp.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: BambooApp.Repo

  def user_factory do
    %BambooApp.Accounts.User{
      username: sequence("username"),
      email: sequence(:email, &"user-#{&1}@test.com")
    }
  end

  def category_factory do
    %BambooApp.Stocks.Category{
      name: sequence(:name, ["technology", "finance", "utility", "manufacturing", "energy"])
    }
  end

  def company_factory do
    %BambooApp.Stocks.Company{
      name: sequence("company"),
      description: sequence("The best in the world"),
      price: 10.0,
      ticker: sequence(:name, ["AMZN", "MSFT", "ABNB", "ALX", "AA"]),
      category: build(:category)
    }
  end

  def user_category_subscription_factory do
    %BambooApp.Subscription.UserCategorySubscription{
      category: build(:category),
      user: build(:user)
    }
  end
end
