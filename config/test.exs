import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :guest_portal, GuestPortal.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "05HZRT1eMm2LO4P8VhAp3xfUC5pll77rJErj9ZtS3lkihwtev2n6ss43E4iLxsDn",
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :core, Sqlite.Repo,
  database: Path.expand("../core_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox
