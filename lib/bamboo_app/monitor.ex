defmodule BambooApp.Monitor do
  @moduledoc false
  use GenServer

  require Logger

  alias BambooApp.Consumer
  alias BambooApp.Stocks

  def start_link(_) do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    send(self(), :ping)

    Logger.info("Monitor was started successfully")
    {:ok, %{}}
  end

  @impl true
  def handle_info(:ping, socket) do
    consumer_pid = :erlang.whereis(Consumer)

    if Process.alive?(consumer_pid) and Stocks.company_added_last_24hours?() do
      Process.send_after(self(), :ping, 60_000)
    else
      fetch_companies()
      |> Enum.chunk_every(2)
      |> Enum.each(fn companies ->
        Enum.map(companies, fn company -> Task.async(fn -> Stocks.create_company(company) end) end)
        |> Task.await_many()
      end)
    end

    {:noreply, socket}
  end

  defp fetch_companies() do
    [
      %{
        name: "Amazon",
        ticker: "AMZN",
        descriptions: "a platform for connecting sellers to buyers",
        price: 1002.2
      },
      %{
        name: "Google",
        ticker: "GOOG",
        descriptions: "a subsidiary of alpahabet",
        price: 500.35
      },
      %{
        name: "Nvidia",
        ticker: "NVDA",
        descriptions: "a platform for connecting sellers to buyers",
        price: 200.0
      }
    ]
  end
end
