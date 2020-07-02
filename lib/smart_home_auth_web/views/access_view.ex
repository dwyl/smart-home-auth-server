defmodule SmartHomeAuthWeb.AccessView do
  use SmartHomeAuthWeb, :view

  def render("show.json", %{user: user_email, door_id: door_id, access: access}) do
    %{email: user_email, door_id: door_id, access: access}
  end
end
