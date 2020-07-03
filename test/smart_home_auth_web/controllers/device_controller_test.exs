defmodule SmartHomeAuthWeb.DeviceControllerTest do
  use SmartHomeAuthWeb.ConnCase

  alias SmartHomeAuth.Account.Device

  @create_attrs %{
    secret: "some secret",
    name: "iPhone",
    type: "mobile_phone"
  }
  @update_attrs %{
    secret: "some updated secret",
    type: "some updated type"
  }
  @invalid_attrs %{secret: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all devices", %{conn: conn} do
      conn = get(conn, Routes.device_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create device" do
    test "renders device when data is valid", %{conn: conn} do
      conn = post(conn, Routes.device_path(conn, :create), device: @create_attrs)
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.device_path(conn, :show, uuid))

      assert %{
               "uuid" => uuid,
               "type" => "mobile_phone"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.device_path(conn, :create), device: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update device" do
    setup [:create_device]

    test "renders device when data is valid",
      %{conn: conn, device: %Device{uuid: uuid} = device} do

      conn = put(conn, Routes.device_path(conn, :update, device), device: @update_attrs)
      assert %{"uuid" => ^uuid} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.device_path(conn, :show, uuid))

      assert %{
               "uuid" => ^uuid,
               "name" => name,
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, device: device} do
      conn = put(conn, Routes.device_path(conn, :update, device), device: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete device" do
    setup [:create_device]

    test "deletes chosen device", %{conn: conn, device: device} do
      conn = delete(conn, Routes.device_path(conn, :delete, device))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.device_path(conn, :show, device))
      end
    end
  end

  defp create_device(_) do
    device = fixture(:device)
    %{device: device}
  end
end
