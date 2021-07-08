defmodule SmartHomeAuthWeb.RBACAuth do
  import Phoenix.Controller
  import Plug.Conn
  alias SmartHomeAuthWeb.Router.Helpers, as: Routes
  alias SmartHomeAuthWeb.IndexLive, as: Index

  @moduledoc """
  A quick & simple plug to authenticate access to routes and
  methods by specifying roles that are allowed to access them.

  ## Example

      plug :only_roles, ["admin"]

  This will only allow users with the role "admin" to access
  the necessary route.
  """

  def only_role(conn, role) when is_binary(role) do
    only_roles(conn, [role])
  end

  def only_roles(conn, check_roles)
      when is_list(check_roles) do
    if RBAC.has_role_any?(conn, check_roles) do
      conn
    else
      conn
      |> put_flash(:error, "You don't have access to this")
      |> redirect(to: Routes.live_path(conn, Index))
      |> halt
    end
  end
end
