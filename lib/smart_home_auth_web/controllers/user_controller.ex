defmodule SmartHomeAuthWeb.UserController do
  use SmartHomeAuthWeb, :controller

  alias SmartHomeAuth.Account
  alias SmartHomeAuth.Account.User

  action_fallback SmartHomeAuthWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user =
      Account.get_user!(id) |> Account.hydrate_user_info()
    render(conn, :show, user: user)
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
