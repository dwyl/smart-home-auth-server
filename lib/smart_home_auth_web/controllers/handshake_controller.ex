defmodule SmartHomeAuthWeb.HandshakeController do
  @moduledoc """
  This is a thin wrapper around the Door controller
  that allows us to assign a Door record to any door
  that tries to handshake with us

  TODO: Move this into websocket
  """
  use SmartHomeAuthWeb, :controller

  require Logger

  alias SmartHomeAuth.Access

  action_fallback SmartHomeAuthWeb.FallbackController
  plug :put_view, SmartHomeAuthWeb.DoorView

  def show(conn, %{"lock" => lock_serial}) do
    Logger.info("Attempting handshake with #{lock_serial}")
    case Access.get_door_by_serial(lock_serial) do
      %Access.Door{} = door ->
        render(conn, "show.json", door: door)
      nil ->
        SmartHomeAuthWeb.DoorController.create(conn, %{"lock" => %{"serial" => lock_serial}})
    end
  end
end
