defmodule SmartHomeAuthWeb.IndexLive do
  use Phoenix.LiveView

  alias SmartHomeAuthWeb.Presence
  alias SmartHomeAuth.Access

  require Logger

  @presence_topic "nodes"

  def mount(_params, _session, socket) do
    SmartHomeAuthWeb.Endpoint.subscribe(@presence_topic)

    current = get_devices()
    SmartHomeAuthWeb.Endpoint.subscribe("events")

    {:ok, assign(socket, current: current, events: [])}
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    current = get_devices()

    {:noreply, assign(socket, current: current)}
  end

  def handle_info(%{event: "event", payload: event}, socket) do
    old_events = socket.assigns.events
    Logger.info(inspect event)
    {:noreply, assign(socket, events: [event | old_events])}
  end

  def get_devices() do
    online = Presence.list("nodes")
      |> Enum.map(fn {device, _metas} -> device end)

    Access.list_doors()
    |> Enum.map(&Map.from_struct(&1))
    |> Enum.map(fn node ->
      add_online_data(node, online)
    end
    )
  end

  defp add_online_data(node, online) do
    if node.serial in online do
      Map.put(node, :status, :online)
    else
      Map.put(node, :status, :offline)
    end
  end
end
