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

  @timeout 1000
  @process_chunk 2

  def start_link(_) do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    send(self(), :ping)

    Logger.info("Monitor was started successfully")
    {:ok, %{page: 1, total: nil}}
  end

  @impl true
  def handle_info(:ping, %{page: page} = state) do
    consumer_pid = :erlang.whereis(Consumer)

    if false and Stocks.company_added_last_24hours?() do
      schedule_next_ping()

      {:noreply, state}
    else
      %{total: total, page_number: page_number, page_size: page_size, data: data} =
        fetch_companies(page)

      :ok = process_data(data)

      state =
        state
        |> Map.put(:page, page_number + 1)
        |> Map.put(:total, total - page_size)

      send(self(), :next_page)

      {:noreply, state}
    end
  end

  def handle_info(:next_page, %{page: _page, total: 0} = state) do
    schedule_next_ping()

    state =
      state
      |> Map.put(:page, 1)
      |> Map.put(:total, nil)

    {:noreply, state}
  end

  def handle_info(:next_page, %{page: page, total: total} = state) do
    %{page_number: page_number, page_size: page_size, data: data} = fetch_companies(page)

    :ok = process_data(data)

    state =
      state
      |> Map.put(:page, page_number + 1)
      |> Map.put(:total, total - page_size)

    send(self(), :next_page)

    {:noreply, state}
  end

  # NB:improvement process the data from the rest api per page before fetching the next page until done
  # we want to avoid loading the entire data of new companies into our memory

  @spec process_data(list()) :: :ok
  defp process_data(data) do
    data
    |> Enum.chunk_every(@process_chunk)
    |> Enum.each(fn companies ->
      Enum.map(companies, fn company ->
        # credo:disable-for-next-line
        Task.async(fn -> company |> atom_keys_to_string_keys() |> Stocks.create_company() end)
      end)
      |> Task.await_many()
    end)
  end

  def fetch_companies(page) do
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

  defp atom_keys_to_string_keys(map) do
    Enum.map(map, fn
      {key, value} -> {to_string(key), value}
    end)
    |> Enum.into(%{})
  end
end
