defmodule SmartHomeAuthWeb.Presence do
  use Phoenix.Presence,
    otp_app: :smart_home_auth,
    pubsub_server: SmartHomeAuth.PubSub
end
