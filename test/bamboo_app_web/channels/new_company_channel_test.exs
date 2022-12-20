defmodule BambooAppWeb.NewCompanyChannelTest do
  @moduledoc false
  use BambooAppWeb.ChannelCase
  import BambooApp.Factory
  alias BambooApp.Stocks

  setup do
    {:ok, _, socket} =
      BambooAppWeb.UserSocket
      |> socket("1", %{})
      |> subscribe_and_join(BambooAppWeb.NewCompanyChannel, "new_companies:technology")

    %{socket: socket}
  end

  test "company broadcasts to new_companies:technology", %{socket: socket} do
    category = insert(:category, name: "technology")
    new_company_params = params_with_assocs(:company, category: category)

    {:ok, %BambooApp.Stocks.Company{id: _id}} = Stocks.create_company(new_company_params)

    assert_broadcast "new_company", msg

    IO.inspect(Jason.decode!(msg))
  end
end
