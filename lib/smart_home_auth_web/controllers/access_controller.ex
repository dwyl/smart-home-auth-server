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

  alias SmartHomeAuth.Access
  alias SmartHomeAuth.Account

  def show(conn, %{"id" => id, "user" => email}) do
    door = Access.get_door!(id)
    user = Account.get_user_by_email(email)
    access = Access.check?(door, user)

    render(conn, "show.json", %{user: user.email, door_id: door.uuid, access: access})
  end

  def show(conn, %{"id" => door_id, "device" => device_id}) do
    door = Access.get_door!(door_id)
    user = Account.get_device_owner(device_id)
    access = Access.check?(door, user)

    render(conn, "show.json", %{user: user.email, door_id: door.uuid, access: access})
  end
end
