defmodule SmartHomeAuthWeb.DeviceController do
  use SmartHomeAuthWeb, :auth_controller

  alias SmartHomeAuth.Account
  alias SmartHomeAuth.Account.Device
  alias SmartHomeAuthWeb.Endpoint

  action_fallback SmartHomeAuthWeb.FallbackController


  def index(conn, _params, current_user) do
    devices = Account.list_user_devices(current_user)
    render(conn, "index.json", devices: devices)
  end

  @doc """
  Register a new device, with a name and type.
  """
  def create(conn, %{"device" => device_params}, current_user) do
    with {:ok, %Device{} = device} <- Account.create_device(current_user, device_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.device_path(conn, :show, device))
      |> render("show.json", device: device)
    end
  end

  def show(conn, %{"id" => id}, _) do
    device = Account.get_device!(id)
    render(conn, "show.json", device: device)
  end

  def update(conn, %{"id" => id, "device" => device_params}, _) do
    device = Account.get_device!(id)

    with {:ok, %Device{} = device} <- Account.update_device(device, device_params) do
      render(conn, "show.json", device: device)
    end
  end

  def delete(conn, %{"id" => id}, _) do
    device = Account.get_device!(id)

    with {:ok, %Device{}} <- Account.delete_device(device) do
      send_resp(conn, :no_content, "")
    end
  end

  def pair(conn, %{"lock" => lock_serial, "name" => name, "type" => type}, current_user) do
    Endpoint.broadcast("lock:" <> lock_serial, "mode:pair", %{user: current_user, name: name, type: type})

    json(conn, %{lock: lock_serial, user: current_user, status: "pairing"})
  end
end
