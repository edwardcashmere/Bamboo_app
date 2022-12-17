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
end
