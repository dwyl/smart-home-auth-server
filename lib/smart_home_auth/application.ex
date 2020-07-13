defmodule SmartHomeAuth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SmartHomeAuth.Repo,
      # Start the Telemetry supervisor
      SmartHomeAuthWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SmartHomeAuth.PubSub},
      # Start our presence tracker
      SmartHomeAuthWeb.Presence,
      # Start the Endpoint (http/https)
      SmartHomeAuthWeb.Endpoint
      # Start a worker by calling: SmartHomeAuth.Worker.start_link(arg)
      # {SmartHomeAuth.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmartHomeAuth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SmartHomeAuthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
