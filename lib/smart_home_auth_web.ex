defmodule SmartHomeAuthWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use SmartHomeAuthWeb, :controller
      use SmartHomeAuthWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: SmartHomeAuthWeb

      import Plug.Conn
      import SmartHomeAuthWeb.Gettext
      import Phoenix.LiveView.Controller
      alias SmartHomeAuthWeb.Router.Helpers, as: Routes
    end
  end

  def auth_controller do
    quote do
      use SmartHomeAuthWeb, :controller

      # Inject the currently logged in person into our handlers.
      def action(conn, _) do
        args = [conn, conn.params, conn.assigns.current_user]
        apply(__MODULE__, action_name(conn), args)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/smart_home_auth_web/templates",
        namespace: SmartHomeAuthWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      import Phoenix.LiveView.Helpers
      # Include shared imports and aliases for views
      unquote(view_helpers())

      def render_field_if_loaded(map, field, key) do
        if Ecto.assoc_loaded?(field) do # Calling Ecto from a view feels wrong
          Map.put(map, key, field)
        else
          map
        end
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Phoenix.LiveView.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import SmartHomeAuthWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import SmartHomeAuthWeb.ErrorHelpers
      import SmartHomeAuthWeb.Gettext
      alias SmartHomeAuthWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
