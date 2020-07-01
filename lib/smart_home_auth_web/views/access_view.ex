defmodule SmartHomeAuthWeb.AccessView do
  use SmartHomeAuthWeb, :view

  def render("show.json", %{userId: user_id, deviceId: device_id, hasAccess: has_access}) do
    %{userId: user_id, deviceId: device_id, hasAccess: has_access}
  end
end
