# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :time_manager_api,
  ecto_repos: [TimeManagerApi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :time_manager_api, TimeManagerApiWeb.Endpoint,
  url: [host: "0.0.0.0"],
  render_errors: [view: TimeManagerApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TimeManagerApi.PubSub,
  live_view: [signing_salt: "+45BzW60"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :time_manager_api, TimeManagerApiWeb.Auth.Guardian,
  issuer: "time_manager_api",
  user_claims: %{"user_id" => :id, "role" => :role},
  secret_key: "VUXytgV7cOhCzSatNtndSzcADEV/VYT8yebhUA42YQpKGpBbDzRZXbR5y4MUtOfR"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "dev.exs"
