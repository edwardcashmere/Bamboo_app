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

  test "company broadcasts to new_companies:technology", %{socket: _socket} do
    _category = insert(:category, name: "technology")

    new_company_params =
      params_with_assocs(:company, name: "amazon", description: "None")
      |> Map.put(:industry, "technology")
      |> Map.delete(:category_id)
      |> atom_keys_to_string_keys()

    {:ok, %BambooApp.Stocks.Company{id: _id}} = Stocks.create_company(new_company_params)

    assert_broadcast "new_company",
                     "{\"company\":{\"name\":\"amazon\",\"description\":\"None\",\"price\":10.0,\"ticker\":\"AMZN\"," <>
                       _other
  end

  defp atom_keys_to_string_keys(map) do
    Enum.map(map, fn
      {key, value} -> {to_string(key), value}
    end)
    |> Enum.into(%{})
  end
end
