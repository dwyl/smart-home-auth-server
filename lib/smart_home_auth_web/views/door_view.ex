defmodule SmartHomeAuthWeb.DoorView do
  use SmartHomeAuthWeb, :view
  alias SmartHomeAuthWeb.DoorView

  require Logger

  def render("index.json", %{doors: doors}) do
    %{data: render_many(doors, DoorView, "door.json")}
  end

  def render("show.json", %{door: door}) do
    %{data: render_one(door, DoorView, "door.json")}
  end

  def render("door.json", %{door: door}) do
    %{uuid: door.uuid,
      name: door.name,
      mode: door.type, # The locks only care about mode
      feature_flags: door.feature_flags,
      serial: door.serial,
      config: door.config,
      roles: door.roles
    }
  end

  def get_all_roles() do
    RBAC.list_approles()
  end
end
