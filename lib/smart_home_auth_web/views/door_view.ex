defmodule SmartHomeAuthWeb.DoorView do
  use SmartHomeAuthWeb, :view
  alias SmartHomeAuthWeb.DoorView

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
      config: door.config
    }
    |> render_field_if_loaded(door.users, :users)
  end
end
