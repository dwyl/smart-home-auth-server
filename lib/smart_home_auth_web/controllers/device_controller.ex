defmodule SmartHomeAuthWeb.DeviceController do
  use SmartHomeAuthWeb, :auth_controller

  alias SmartHomeAuth.Account
  alias SmartHomeAuth.Account.Device
  alias SmartHomeAuth.Access
  alias SmartHomeAuthWeb.Endpoint

  action_fallback SmartHomeAuthWeb.FallbackController

  plug :load_locks when action in [:new_pair, :create_pair, :pair]

  defp load_locks(conn, _) do
    assign(conn, :locks, Access.list_doors())
  end

  def index(conn, _params, current_user) do
    devices = Account.list_user_devices(current_user)
    render(conn, :index, devices: devices)
  end

  @doc """
  Register a new device, with a name and type.
  """
  def create(conn, %{"device" => device_params}, current_user) do
    with {:ok, %Device{} = device} <- Account.create_device(current_user, device_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.device_path(conn, :show, device))
      |> render(:show, device: device)
    end
  end

  def edit(conn, %{"id" => uuid}, current_user) do
    device = Account.get_user_device!(current_user, uuid)
    changeset = Account.change_device(device)

    render(conn, "edit.html", device: device, changeset: changeset)
  end

  def show(conn, %{"id" => id}, _) do
    device = Account.get_device!(id)
    render(conn, :show, device: device)
  end

  def update(conn, %{"id" => id, "device" => device_params}, _) do
    device = Account.get_device!(id)

    with {:ok, %Device{} = device} <- Account.update_device(device, device_params) do
      if get_format(conn) == "html" do
        redirect(conn, to: Routes.device_path(conn, :index))
      else
        render(conn, :show, device: device)
      end
    end
  end

  def delete(conn, %{"id" => id}, _) do
    device = Account.get_device!(id)

    with {:ok, %Device{}} <- Account.delete_device(device) do
      if get_format(conn) == "html" do
        redirect(conn, to: Routes.device_path(conn, :index))
      else
        send_resp(conn, :no_content, "")
      end
    end
  end

  def new_pair(conn, _params, _current_user) do
    pair = Account.change_pair(%{})

    render(conn, "new_pair.html", pair: pair)
  end

  def create_pair(conn,
    %{"pair" => pair_data}, current_user) do

    change = Account.change_pair(%{}, pair_data)

    case Ecto.Changeset.apply_action(change, :update) do
      {:ok, %{lock: lock_serial, name: name, type: type}} ->
        pair_data = %{lock: lock_serial, user: current_user, name: name, type: type}
        Endpoint.broadcast("lock:" <> lock_serial, "mode:pair", pair_data)

        render(conn, "create_pair.html", pair_data: pair_data)

      {:error, changeset} ->
        render(conn, "new_pair.html", pair: changeset)
    end
  end

  # API method, leaving this here for now.
  # Trying to write a common pair function seems like a backward step in
  # code readability.
  def pair(conn, %{"lock" => lock_serial, "name" => name, "type" => type}, current_user) do
    Endpoint.broadcast("lock:" <> lock_serial, "mode:pair", %{user: current_user, name: name, type: type})

    json(conn, %{lock: lock_serial, user: current_user, status: "pairing"})
  end
end
