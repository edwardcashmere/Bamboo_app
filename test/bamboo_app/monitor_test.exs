defmodule BambooApp.MonitorTest do
  @moduledoc false
  use BambooApp.DataCase

  alias BambooApp.Monitor

  describe "call_api" do
    setup do
      pid = start_supervised!({Monitor, [name: "test_name"]})
      [pid: pid]
    end

    test "when invoked call_api, get all the data from all the pages" do
      assert Monitor.call_api() |> length == 6
    end
  end
end
