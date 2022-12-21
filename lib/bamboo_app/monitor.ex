defmodule BambooApp.Monitor do
  @moduledoc """
  This GenServer serves only one function , it decides checks on the health
  of the consumer and if companies are still being sent over the provided PubSub
  it then decides whether to make a call to the Rest API endpoint to fetch new companies
  assuming no events are coming through from the PubSub or the consumer is down.

  call_api is just a mock of the example api that is to be called, assuming it is paginated

  """
  use GenServer

  require Logger

  alias BambooApp.Consumer
  alias BambooApp.Stocks

  @timeout 60_000

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
      schedule_next_ping()
    else
      call_api()
      |> Enum.chunk_every(2)
      |> Enum.each(fn companies ->
        Enum.map(companies, fn company -> Task.async(fn -> Stocks.create_company(company) end) end)
        |> Task.await_many()

        schedule_next_ping()
      end)
    end

    {:noreply, socket}
  end

  # NB:improvement process the data from the rest api per page before fetching the next page until done
  # we want to avoid loading the entire data of new companies into our memory

  def call_api(_, 0) do
    []
  end

  def call_api(page, total) do
    %{page_size: page_size, page_number: page_number, data: data} = fetch_companies(page)
    data ++ call_api(page_number + 1, total - page_size)
  end

  def call_api(page \\ 1) do
    %{total: total, page_size: page_size, page_number: page_number, data: data} =
      fetch_companies(page)

    data ++ call_api(page_number + 1, total - page_size)
  end

  defp fetch_companies(page) do
    Enum.find(data(), fn %{page_number: page_number} -> page_number == page end)
  end

  defp schedule_next_ping() do
    Process.send_after(self(), :ping, @timeout)
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
            description: "a platform for connecting sellers to buyers",
            price: 1002.2,
            industry: "technology"
          },
          %{
            name: "Google",
            ticker: "GOOG",
            description: "a subsidiary of alpahabet",
            price: 500.35,
            industry: "advertising"
          },
          %{
            name: "Nvidia",
            ticker: "NVDA",
            description: "a platform for connecting sellers to buyers",
            price: 200.0,
            industry: "Gaming"
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
            description: "a platform for connecting sellers to buyers in africa",
            price: 500.55,
            industry: "technology"
          },
          %{
            name: "Safaricom",
            ticker: "SAF",
            description: "Telecom company",
            price: 90.34,
            industry: "Telecom"
          },
          %{
            name: "Binance",
            ticker: "BNN",
            description: "a crypto currency exchange platform",
            price: 300.0,
            industry: "Finance"
          }
        ]
      }
    ]
  end
end
