defmodule BambooApp.MonitorTest do
  @moduledoc false
  use BambooApp.DataCase

  alias BambooApp.Monitor

  describe "call_api" do
    setup do
      pid = start_supervised!({Monitor, [name: "test_name"]})
      [pid: pid]
    end

    test "when invoked fetch_companies, get all the data from all the pages" do
      assert Monitor.fetch_companies(1).data |> length() == 3
    end

    test "test initial conditions of monitor" do
      assert Monitor.init(:ok) == {:ok, %{page: 1, total: nil}}
    end
  end
end
