defmodule SmartHomeAuthWeb.UserView do
  use SmartHomeAuthWeb, :view
  alias SmartHomeAuthWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
    |> render_field_if_loaded(user.doors, :doors)
    |> render_field_if_loaded(user.devices, :devices)

  end
end
