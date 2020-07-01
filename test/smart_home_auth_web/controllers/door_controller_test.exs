defmodule SmartHomeAuthWeb.DoorControllerTest do
  use SmartHomeAuthWeb.ConnCase

  alias SmartHomeAuth.Access
  alias SmartHomeAuth.Access.Door

  @create_attrs %{
    name: "some name",
    type: 42
  }
  @update_attrs %{
    name: "some updated name",
    type: 43
  }
  @invalid_attrs %{name: nil, type: nil}

  def fixture(:door) do
    {:ok, door} = Access.create_door(@create_attrs)
    door
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all doors", %{conn: conn} do
      conn = get(conn, Routes.door_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create door" do
    test "renders door when data is valid", %{conn: conn} do
      conn = post(conn, Routes.door_path(conn, :create), door: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.door_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "type" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.door_path(conn, :create), door: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update door" do
    setup [:create_door]

    test "renders door when data is valid", %{conn: conn, door: %Door{id: id} = door} do
      conn = put(conn, Routes.door_path(conn, :update, door), door: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.door_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "type" => 43
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
