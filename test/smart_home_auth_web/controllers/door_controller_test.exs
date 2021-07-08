defmodule SmartHomeAuthWeb.DoorControllerTest do
  use SmartHomeAuthWeb.ConnCase

  alias SmartHomeAuth.Access.Door

  @create_attrs %{
    name: "some name",
    type: 1,
    serial: "lock-1234",
    feature_flags: [],
    roles: []
  }
  @update_attrs %{
    name: "some updated name",
    type: 2
  }
  @invalid_attrs %{serial: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all doors", %{conn: conn} do
      conn = get(conn, Routes.door_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end


  describe "update door" do
    setup [:create_door]

    test "renders door when data is valid", %{conn: conn, door: %Door{uuid: uuid} = door} do
      conn = put(conn, Routes.door_path(conn, :update, door), door: @update_attrs)
      assert %{"uuid" => ^uuid} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.door_path(conn, :show, uuid))

      assert %{
               "uuid" => uuid,
               "name" => "some updated name",
               "mode" => 2
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, door: door} do
      conn = put(conn, Routes.door_path(conn, :update, door), door: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete door" do
    setup [:create_door]

    test "deletes chosen door", %{conn: conn, door: door} do
      conn = delete(conn, Routes.door_path(conn, :delete, door))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.door_path(conn, :show, door))
      end
    end
  end

  defp create_door(_) do
    door = fixture(:door)
    %{door: door}
  end
end
