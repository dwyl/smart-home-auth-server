defmodule SmartHomeAuthWeb.UserMapper do
  @moduledoc """
  Hacky way round being able to relate to users that don't yet exist in
  our database.

  We check for if user exists and if not create one. This should allow for
  a seamless transition between Dwyl auth and this application.
  """
  import Plug.Conn
  alias SmartHomeAuth.Account

  def init(opts), do: opts

  def call(conn, _opts) do
    user_email = conn.assigns.person.email

    cond do
      conn.assigns[:current_user] -> # Bypass for testing
        conn

      # First check user_email is not nil to avoid any weird errors
      user = user_email && Account.get_user_by_email(user_email) ->
        conn
        |> sync_user_roles(user) # Sync as often as possible
        |> put_current_user(user)

      # If we can't find a record in our database, make one
      {:ok, user} = user_email && Account.create_user(%{email: user_email}) ->
        put_current_user(conn, user)

      # I don't *think* we want to crash here, so lets pretend everythings fine
      # and move on
      true ->
        assign(conn, :current_user, nil)
    end
  end

  defp sync_user_roles(%{assigns: %{person: %{roles: roles}}} = conn, user) do
    unless Enum.sort(roles) == Enum.sort(user.roles) do
      # Update our user roles.
      Account.update_user(user, %{roles: roles})
    end
    conn
  end

  defp put_current_user(conn, user) do
    assign(conn, :current_user, user)
  end
end
