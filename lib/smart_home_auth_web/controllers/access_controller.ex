defmodule SmartHomeAuthWeb.AccessController do
  @moduledoc """
  This controller works out wether a specific user can access a device
  It should reply with to a access check request with a simple response
  `{
    deviceId: The ID of the device to open
    userId: The user that requested the open
    hasAccess: bool - weather or not the user can interact with the device
  }
  """

  use SmartHomeAuthWeb, :controller

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", %{deviceId: id, userId: 1, hasAccess: true})
  end
end
