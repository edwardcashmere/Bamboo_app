defmodule BambooApp.StocksTest do
  @moduledoc false
  use BambooApp.DataCase

  alias BambooApp.Stocks

  describe "categories" do
    alias BambooApp.Stocks.Category

    @invalid_attrs %{name: nil}

    setup do
      category = insert(:category)
      [category: category]
    end

    test "list_categories/0 returns all categories", %{category: category} do
      assert Stocks.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id", %{category: category} do
      assert Stocks.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: name} = params_for(:category)

      assert {:ok, %Category{name: ^name}} = Stocks.create_category(valid_attrs)
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category", %{category: category} do
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Stocks.update_category(category, update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset", %{category: category} do
      assert {:error, %Ecto.Changeset{}} = Stocks.update_category(category, @invalid_attrs)
      assert category == Stocks.get_category!(category.id)
    end

    test "delete_category/1 deletes the category", %{category: category} do
      assert {:ok, %Category{}} = Stocks.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset", %{category: category} do
      assert %Ecto.Changeset{} = Stocks.change_category(category)
    end
  end

  describe "conpanies" do
    alias BambooApp.Stocks.Company

    import BambooApp.StocksFixtures

    @invalid_attrs %{description: nil, name: nil, price: nil, ticker: nil}

    test "list_conpanies/0 returns all conpanies" do
      company = company_fixture()
      assert Stocks.list_conpanies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Stocks.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{description: "some description", name: "some name", price: 120.5, ticker: "some ticker"}

      assert {:ok, %Company{} = company} = Stocks.create_company(valid_attrs)
      assert company.description == "some description"
      assert company.name == "some name"
      assert company.price == 120.5
      assert company.ticker == "some ticker"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name", price: 456.7, ticker: "some updated ticker"}

      assert {:ok, %Company{} = company} = Stocks.update_company(company, update_attrs)
      assert company.description == "some updated description"
      assert company.name == "some updated name"
      assert company.price == 456.7
      assert company.ticker == "some updated ticker"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Stocks.update_company(company, @invalid_attrs)
      assert company == Stocks.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Stocks.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Stocks.change_company(company)
    end
  end
end
