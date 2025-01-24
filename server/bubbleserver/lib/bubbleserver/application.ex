defmodule Bubbleserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BubbleserverWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:bubbleserver, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bubbleserver.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bubbleserver.Finch},
      # Start the main game server
      GameState,

      # Start a worker by calling: Bubbleserver.Worker.start_link(arg)
      # {Bubbleserver.Worker, arg},
      # Start to serve requests, typically the last entry
      BubbleserverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bubbleserver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BubbleserverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
