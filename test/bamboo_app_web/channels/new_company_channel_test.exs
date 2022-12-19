defmodule BambooAppWeb.NewCompanyChannelTest do
  @moduledoc false
  use BambooAppWeb.ChannelCase
  alias BambooApp.Stocks

  # setup do
  #   {:ok, _, socket} =
  #     BambooAppWeb.UserSocket
  #     |> socket(1, %{})
  #     |> subscribe_and_join(BambooAppWeb.NewCompanyChannel, "new_companies:technology")

  #   %{socket: socket}
  # end

  # test "company broadcasts to new_companies:technology", %{socket: socket} do
  #   new_company_params = params_with_assocs(:company)

  #   {:ok, %BambooApp.Stocks.Company{id: _id}} = Stocks.create_company(new_company_params)

  #   assert_broadcast _, %{"company" => company}

  #   IO.inspect(company)
  # end
end
