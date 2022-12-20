defmodule BambooApp.MonitorTest do
  @moduledoc false
  use BambooApp.DataCase, async: true

  alias BambooApp.Monitor

  setup do
    start_supervised(Monitor)
  end

  # describe "call_api" do
  #   test "when invoked call_api, get all the data from all the pages" do
  #    Monitor.call_api()
  #   end
  # end
end
