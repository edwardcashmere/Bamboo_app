defmodule BambooApp.Workers.PollNewCompaniesWorker do
  @moduledoc """
   The worker defined in this module will poll an external api for new companies only if
   our consumer is down or 24hours after the...
  """
  use Oban.Worker

  @impl true
  def perform(%{args: %{"run" => true}}) do
    fetch_companies()
  end

  def perform(_) do
    :ok
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
