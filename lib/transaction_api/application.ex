defmodule TransactionApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TransactionApiWeb.Telemetry,
      TransactionApi.Repo,
      {DNSCluster, query: Application.get_env(:transaction_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TransactionApi.PubSub},
      # Start a worker by calling: TransactionApi.Worker.start_link(arg)
      # {TransactionApi.Worker, arg},
      # Start to serve requests, typically the last entry
      TransactionApiWeb.Endpoint,
      Server.TransactionServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TransactionApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TransactionApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
