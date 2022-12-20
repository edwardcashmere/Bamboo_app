defmodule BambooApp.MonitorSupervisor do
  @moduledoc false
  # Automatically defines child_spec/1
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      {BambooApp.Monitor, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
