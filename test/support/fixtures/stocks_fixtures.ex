defmodule BambooApp.StocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BambooApp.Stocks` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> BambooApp.Stocks.create_category()

    category
  end

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: 120.5,
        ticker: "some ticker"
      })
      |> BambooApp.Stocks.create_company()

    company
  end
end
