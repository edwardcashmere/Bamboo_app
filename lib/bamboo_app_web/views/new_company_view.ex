defmodule BambooAppWeb.CompanyView do
  use BambooAppWeb, :view

  def render("companies.json", %{companies: companies}) do
    %{data: render_many(companies, __MODULE__, "default.json")}
  end

  def render("company.json", %{company: company}) do
    %{data: render_one(company, __MODULE__, "default.json")}
  end

  def render("default.json", %{company: company}) do
    %{
      id: company.id,
      name: company.name,
      description: company.description,
      price: company.price,
      ticker: company.ticker,
      category: company.category.name
    }
  end
end
