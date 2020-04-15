# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :demo_heroku_deployment, DemoWeb.Endpoint,
    load_from_system_env: true,
    # Don't forget to replace pure-peak-67829 with the name of your Phoenix application that was created.
    url: [scheme: "https", host: "fathomless-stream-80884.herokuapp.com", port: 80],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")
  
  config :demo_heroku_deployment, DemoWeb.Repo,
    adapter: Ecto.Adapters.Postgres,
      url: System.get_env("DATABASE_URL"),
      pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
      ssl: true
  
  
  config :logger, level: :info

config :demo, Demo.Repo,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :demo, DemoWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :demo, DemoWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
