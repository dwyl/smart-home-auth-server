defmodule SmartHomeAuthWeb.PairLive do
  use Phoenix.LiveView

  require Logger

  def mount(_params, session, socket) do
    SmartHomeAuthWeb.Endpoint.subscribe("lock:" <> session["lock"])
    {:ok, assign(socket, status: :waiting)}
  end

  def handle_info(%{event: "pair:complete", payload: payload}, socket) do
    {:noreply, assign(socket, status: :complete, payload: payload)}
  end
end
