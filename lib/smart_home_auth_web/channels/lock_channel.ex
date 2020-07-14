defmodule SmartHomeAuthWeb.LockChannel do
  use SmartHomeAuthWeb, :channel

  require Logger

  alias SmartHomeAuth.Access
  alias SmartHomeAuth.Account
  alias SmartHomeAuth.Access.Door
  alias SmartHomeAuthWeb.DoorView
  alias SmartHomeAuthWeb.Presence

  @impl true
  def join("lock:" <> lock_serial, _payload, socket) do
    Logger.info("Attempting handshake with #{lock_serial}")

    lock = find_or_create(lock_serial)
      |> Phoenix.View.render_one(DoorView, "door.json")

    Logger.info("#{lock.serial} has come online")

    send(self(), :after_join)

    {:ok, lock, assign(socket, :lock, lock)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(self(), "nodes", socket.assigns.name, %{
      name: socket.assigns.name,
      online_at: inspect(System.system_time(:second))
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("reset", _msg, socket) do
    lock = Access.get_door!(socket.assigns.lock_uuid)
    |> Phoenix.View.render_one(DoorView, "door.json")

    {:reply, {:ok, lock}, socket}
  end

  def handle_in("pair:complete", message, socket) do
    result =
      message
      |> Map.fetch!("user") |> Map.fetch!("id")
      |> Account.get_user!()
      |> Account.create_device(message)

    Logger.info("Completed pair, created device: #{inspect result}")

    {:reply, :ok, socket}
  end

  # Handle an access request
  def handle_in("access:request", %{"uuid" => uuid, "device" => device_serial}, socket) do
    door = Access.get_door!(uuid)
    user = Account.get_device_owner(device_serial)
    access = Access.check?(door, user)

    {:reply, {:ok, %{user: user, access: access}}, socket}
  end

  def handle_in("event", event, socket) do
    SmartHomeAuthWeb.Endpoint.broadcast_from!(self(), "events", "event",
      %{from: socket.assigns.name, message: event})

    {:reply, :ok, socket}
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
