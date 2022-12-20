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
    Process.send_after(self(), :ping, 1000)

    # if Process.alive?(consumer_pid) and Stocks.company_added_last_24hours?() do
    #   Process.send_after(self(), :ping, 60_000)
    # else
    #   call_api()
    #   |> Enum.chunk_every(2)
    #   |> Enum.each(fn companies ->
    #     Enum.map(companies, fn company -> Task.async(fn -> Stocks.create_company(company) end) end)
    #     |> Task.await_many()
    #   end)

    # end

    {:noreply, socket}
  end

  def call_api(_, 0) do
    []
  end

  def call_api(page_number, total) do
    %{page_size: page_size, page_number: page_number, data: data} = fetch_companies(page_number)
    call_api(page_number + 1, total - page_size)
    data
  end

  def call_api(page_number \\ 1) do
    %{total: total, page_size: page_size, page_number: page_number, data: data} =
      fetch_companies(page_number)

    call_api(page_number + 1, total - page_size)
    data
  end

  defp fetch_companies(page_number) do
    Enum.find(data(), fn %{page: page} -> page == page_number end)
  end

  def data() do
    [
      %{
        total: 6,
        page_size: 3,
        page_number: 1,
        data: [
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
      },
      %{
        total: 6,
        page_size: 3,
        page_number: 2,
        data: [
          %{
            name: "Jumia",
            ticker: "JMI",
            descriptions: "a platform for connecting sellers to buyers in africa",
            price: 500.55
          },
          %{
            name: "Safaricom",
            ticker: "SAF",
            descriptions: "Telecom company",
            price: 90.34
          },
          %{
            name: "Binance",
            ticker: "BNN",
            descriptions: "a crypto currency exchange platform",
            price: 300.0
          }
        ]
      }
    ]
  end
end
