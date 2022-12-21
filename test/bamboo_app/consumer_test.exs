defmodule BambooApp.ConsumerTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias BambooApp.Stocks.Company

  import BambooApp.Factory

  setup do
    [
      message: %{
        name: "Amazon",
        ticker: "AMZN",
        description: "a platform for connecting sellers to buyers",
        price: 1002.2,
        industry: "technology"
      }
    ]
  end

  test "test message", %{message: message} do
    ref = Broadway.test_message(BambooApp.Consumer, message)
    assert_receive {:ack, ^ref, [%{data: {:ok, %Company{ticker: "AMZN"}}}], []}
  end
end
