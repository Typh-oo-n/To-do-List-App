defmodule Mytodo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MytodoWeb.Telemetry,
      Mytodo.Repo,
      {DNSCluster, query: Application.get_env(:mytodo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mytodo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mytodo.Finch},
      # Start a worker by calling: Mytodo.Worker.start_link(arg)
      # {Mytodo.Worker, arg},
      # Start to serve requests, typically the last entry
      MytodoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mytodo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MytodoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
