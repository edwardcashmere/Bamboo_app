import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bamboo_app, BambooApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "bamboo_app_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bamboo_app, BambooAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ScxyNDljKLp1RAp8Okt37vYUe2UGNK+pT20hFTqXeZQYLqCPZSx0vDY6UKLsCr/P",
  server: false

# In test we don't send emails.
config :bamboo_app, BambooApp.Mailer, adapter: Swoosh.Adapters.Test

# config/test.exs
config :bamboo_app, Oban, testing: :manual

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :bamboo_app,
  producer_module: Broadway.DummyProducer,
  producer_options: [] # change if required for your dev/prod producer
