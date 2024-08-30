defmodule PheonixLab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PheonixLabWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:pheonix_lab, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PheonixLab.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PheonixLab.Finch},
      # Start a worker by calling: PheonixLab.Worker.start_link(arg)
      # {PheonixLab.Worker, arg},
      # Start to serve requests, typically the last entry
      PheonixLabWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PheonixLab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PheonixLabWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
