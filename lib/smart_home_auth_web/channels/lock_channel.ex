defmodule SmartHomeAuthWeb.LockChannel do
  use SmartHomeAuthWeb, :channel

  require Logger

  alias Phoenix.Socket.Broadcast

  alias SmartHomeAuth.Access
  alias SmartHomeAuth.Account
  alias SmartHomeAuth.Access.Door
  alias SmartHomeAuthWeb.DoorView
  alias SmartHomeAuthWeb.Presence

  @impl true
  def join("lock:" <> lock_serial, _payload, socket) do
    Logger.info("Attempting handshake with #{lock_serial}")

    lock =
      find_or_create(lock_serial)
      |> Phoenix.View.render_one(DoorView, "door.json")

    Logger.info("#{lock.serial} has come online")

    send(self(), :after_join)

    {:ok, lock, assign(socket, :lock, lock)}
  end

  @impl true
  def handle_in("reset", _msg, socket) do
    lock =
      Access.get_door!(socket.assigns.lock.uuid)
      |> Phoenix.View.render_one(DoorView, "door.json")

    {:reply, {:ok, lock}, assign(socket, :lock, lock)}
  end

  def handle_in("pair:complete" = event, message, socket) do
    # In case anyone is listening
    broadcast_from(socket, event, message)

    result =
      message
      |> Map.fetch!("user")
      |> Map.fetch!("id")
      |> Account.get_user!()
      |> Account.create_device(message)

    Logger.info("Completed pair, created device: #{inspect(result)}")

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
    Logger.info("Got event in")
    SmartHomeAuthWeb.Endpoint.broadcast_from!(self(), "events", "event", %{
      from: socket.assigns.name,
      message: event
    })

    SmartHomeAuthWeb.Endpoint.broadcast_from!(self(), "events:" <> socket.assigns.lock.serial, "event", %{
      from: socket.assigns.name,
      message: event
    })

    {:reply, :ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(self(), "nodes", socket.assigns.name, %{
        name: socket.assigns.name,
        online_at: inspect(System.system_time(:second))
      })

    features_subscribe(socket.assigns.lock.feature_flags, socket)

    {:noreply, socket}
  end

  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    Logger.debug("Handling external event")
    push(socket, event, payload)

    {:noreply, socket}
  end

  defp find_or_create(lock_serial) do
    case Access.get_door_by_serial(lock_serial) do
      %Access.Door{} = door ->
        door

      nil ->
        with {:ok, %Door{} = door} <- Access.create_door(%{
          "serial" => lock_serial,
          "feature_flags" => [],
          "name" => "new" <> lock_serial
          }) do
          door
        end
    end
  end

  defp features_subscribe(features, socket) do
    Enum.each(features, &feature_subscribe(&1, socket))
  end

  def feature_subscribe("display", socket) do
    master = socket.assigns.lock.config["display"]["master"]
    Logger.debug("Subscribing and configuring display: master #{master}")
    SmartHomeAuthWeb.Endpoint.subscribe("events:" <> master)
  end

  def feature_subscribe(_unimplented, _socket) do
    :ok
  end
end
