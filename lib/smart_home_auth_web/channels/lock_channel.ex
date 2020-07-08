defmodule SmartHomeAuthWeb.LockChannel do
  use SmartHomeAuthWeb, :channel

  require Logger

  alias SmartHomeAuth.Access
  alias SmartHomeAuth.Access.Door
  alias SmartHomeAuthWeb.DoorView

  @impl true
  def join("lock:" <> lock_serial, _payload, socket) do
    Logger.info("Attempting handshake with #{lock_serial}")

    lock = find_or_create(lock_serial)
      |> Phoenix.View.render_one(DoorView, "door.json")

    Logger.info("#{lock.serial} has come online")
    {:ok, lock, assign(socket, :lock_uuid, lock.uuid)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (lock:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  defp find_or_create(lock_serial) do
    case Access.get_door_by_serial(lock_serial) do
      %Access.Door{} = door ->
        door
      nil ->
        with {:ok, %Door{} = door} <- Access.create_door(%{"serial" => lock_serial}) do
          door
        end
    end
  end
end
