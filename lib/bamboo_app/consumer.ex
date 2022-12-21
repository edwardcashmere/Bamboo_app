defmodule BambooApp.Consumer do
  @moduledoc false
  use Broadway

  require Logger
  alias BambooApp.Stocks
  alias Broadway.Message

  def start_link(_opts) do
    Logger.info("Rabbitmq started")

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "new_companies",
           connection: [
             username: "user",
             password: "password"
           ],
           qos: [
             prefetch_count: 50
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(&process_data/1)
  end

  defp process_data(message) do
    Logger.info("I was received #{message}")

    message
    |> Stocks.create_company()
  end
end
