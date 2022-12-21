defmodule BambooApp.ConsumerTest do
  @moduledoc false
  use BambooApp.DataCase
  alias BambooApp.Stocks.Company

  setup do
    [
      message: %{
        name: "amazon",
        ticker: "AMZN",
        description: "a platform for connecting sellers to buyers",
        price: 1002.2,
        industry: "technology"
      }
    ]
  end

  test "test message", %{message: message} do
    ref = Broadway.test_message(BambooApp.Consumer, Jason.encode!(message))
    assert_receive {:ack, ^ref, [%{data: {:ok, %Company{ticker: "AMZN"}}}], []}
  end
end
