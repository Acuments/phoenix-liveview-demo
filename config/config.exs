# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :demo,
  ecto_repos: [Demo.Repo]

# Configures the endpoint
config :demo, DemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ulu05BwEnJAMz2HoA1Zv7WfeGbj/+Pr9cFYixix42veKQrmdVRl9UNPICzr19HjK",
  render_errors: [view: DemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: [name: Demo.PubSub],
  live_view: [signing_salt: "Afek0oXW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# rRende

config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
