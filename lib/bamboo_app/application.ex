defmodule BambooApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BambooAppWeb.Telemetry,
      # Start the Ecto repository
      BambooApp.Repo,
      # Start the PubSub system
      {BambooApp.Consumer, []},

      {Oban, Application.fetch_env!(:bamboo_app, Oban)},
      {Phoenix.PubSub, name: BambooApp.PubSub},
      # Start Finch
      {Finch, name: BambooApp.Finch},
      # Start the Endpoint (http/https)
      BambooAppWeb.Endpoint
      # {BambooApp.Monitor, []}

      # Start a worker by calling: BambooApp.Worker.start_link(arg)
      # {BambooApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BambooApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BambooAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
