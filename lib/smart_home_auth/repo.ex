defmodule SmartHomeAuth.Repo do
  use Ecto.Repo,
    otp_app: :smart_home_auth,
    adapter: Ecto.Adapters.Postgres
end
