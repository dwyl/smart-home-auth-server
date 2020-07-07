use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :smart_home_auth, SmartHomeAuth.Repo,
  username: "test",
  password: "",
  database: "smart_home_auth_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :smart_home_auth, SmartHomeAuthWeb.Endpoint,
  http: [port: 4002],
  server: false

config :smart_home_auth,
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoX3Byb3ZpZGVyIjoiZ2l0aHViIiwiZW1haWwiOiJ0b21AdG9taGFpbmVzLnVrIiwiZ2l2ZW5OYW1lIjoiVG9tIEhhaW5lcyIsImlkIjo5MDg5MDU2LCJwaWN0dXJlIjoiaHR0cHM6Ly9hdmF0YXJzMi5naXRodWJ1c2VyY29udGVudC5jb20vdS85MDg5MDU2P3Y9NCIsInN0YXR1cyI6MSwiYXVkIjoiSm9rZW4iLCJleHAiOjE2MjUxMzQzMzUsImlhdCI6MTU5MzU5NzMzNSwiaXNzIjoiSm9rZW4iLCJqdGkiOiIyb2VwZ2xhYzljNXBzM3RrbmMwMDAwMDQiLCJuYmYiOjE1OTM1OTczMzV9.tJuI68AWLxBGGu_Bhs45FC8p7KA18WPkwMPktnrztWU"

# Print only warnings and errors during test
config :logger, level: :warn
