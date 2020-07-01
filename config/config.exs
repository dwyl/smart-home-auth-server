# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :smart_home_auth,
  ecto_repos: [SmartHomeAuth.Repo]

# Configures the endpoint
config :smart_home_auth, SmartHomeAuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rQXicHfajoynUJ/rk4Ve5lb5dYEV5G0PwVMCY63yrn5xAU+QIC3jgI7YM1VvHSOL",
  render_errors: [view: SmartHomeAuthWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: SmartHomeAuth.PubSub,
  live_view: [signing_salt: "yxPL93gA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
