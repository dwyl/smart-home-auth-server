defmodule SmartHomeAuthWeb.AccessView do
  use SmartHomeAuthWeb, :view

  def render("show.json", %{user_email: user_email, doorId: door_id, hasAccess: has_access}) do
    %{user_email: user_email, door_id: door_id, has_access: has_access}
  end
end
