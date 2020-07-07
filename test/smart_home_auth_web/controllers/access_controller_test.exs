defmodule SmartHomeAuthWeb.AccessControllerTest do
  use SmartHomeAuthWeb.ConnCase

  alias SmartHomeAuth.Access


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authorisation" do
    setup [:create_authorised]

    test "allows access when user is keyholder", %{conn: conn, user: user, door: door} do

      conn = get(conn, Routes.access_path(conn, :show, door.uuid), user: user.email)

      assert true = json_response(conn, 200)["access"]
    end

    test "allows access through user device", %{conn: conn, user: user, door: door} do
      device = fixture(:device, user)

      conn = get(conn, Routes.access_path(conn, :show, door.uuid), device: device.uuid)

      assert true = json_response(conn, 200)["access"]
    end
  end

  defp create_authorised(_) do
    door = fixture(:door)
    user = fixture(:user)

    {:ok, door} = Access.update_door(door, %{"users" => [user.email]})

    %{user: user, door: door}
  end
end
