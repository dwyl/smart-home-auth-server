defmodule SmartHomeAuthWeb.DoorController do
  use SmartHomeAuthWeb, :controller

  alias SmartHomeAuth.Access
  alias SmartHomeAuth.Access.Door

  action_fallback SmartHomeAuthWeb.FallbackController

  def index(conn, _params) do
    doors = Access.list_doors()
    render(conn, "index.json", doors: doors)
  end

  def create(conn, %{"lock" => door_params}) do
    with {:ok, %Door{} = door} <- Access.create_door(door_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.door_path(conn, :show, door))
      |> render("show.json", door: door)
    end
  end

  def show(conn, %{"id" => id}) do
    door = Access.get_door!(id)
    render(conn, "show.json", door: door)
  end

  def update(conn, %{"id" => id, "door" => door_params}) do
    door = Access.get_door!(id)

    with {:ok, %Door{} = door} <- Access.update_door(door, door_params) do
      render(conn, "show.json", door: door)
    end
  end

  def delete(conn, %{"id" => id}) do
    door = Access.get_door!(id)

    with {:ok, %Door{}} <- Access.delete_door(door) do
      send_resp(conn, :no_content, "")
    end
  end
end
