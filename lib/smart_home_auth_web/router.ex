defmodule SmartHomeAuthWeb.Router do
  use SmartHomeAuthWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AuthPlug, %{auth_url: "https://dwylauth.herokuapp.com"}
    plug SmartHomeAuthWeb.UserMapper
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :live_routes do
    plug :browser
    plug :fetch_live_flash
    plug :put_root_layout, {SmartHomeAuthWeb.LayoutView, :app}
  end

  pipeline :auth do
    plug :fetch_session # Allows us to use cookie-based authentication - do we actually need to support this?
    plug AuthPlug, %{auth_url: "https://dwylauth.herokuapp.com"}
    plug SmartHomeAuthWeb.UserMapper
  end

  pipeline :admin_only do
    plug :only_role, "admin"
  end

  scope "/", SmartHomeAuthWeb do
    pipe_through :live_routes

    live "/", IndexLive
  end

  scope "/", SmartHomeAuthWeb do
    pipe_through :browser

    get "/devices/pair", DeviceController, :new_pair
    post "/devices/pair", DeviceController, :create_pair

    resources "/devices", DeviceController, except: [:new]

    get "/access/:id", AccessController, :show
  end

  scope "/manage", SmartHomeAuthWeb do
    pipe_through [:browser, :admin_only]

    resources "/locks", DoorController, except: [:new]
    resources "/users", UserController
  end

  scope "/api/v0", SmartHomeAuthWeb do
    pipe_through :api
    pipe_through :auth

    resources "/locks", DoorController, except: [:new, :edit] # Need to refractor doors to locks
    resources "/users", UserController, except: [:new, :edit, :create, :update]
    resources "/devices", DeviceController, except: [:new, :edit]
    post "/devices/pair", DeviceController, :pair
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery, :auth]
      live_dashboard "/dashboard", metrics: SmartHomeAuthWeb.Telemetry
    end
  end
end
