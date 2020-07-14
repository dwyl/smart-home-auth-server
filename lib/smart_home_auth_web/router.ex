defmodule SmartHomeAuthWeb.Router do
  use SmartHomeAuthWeb, :router

  pipeline :browser do
    plug :accepts, ["json", "html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {SmartHomeAuthWeb.LayoutView, :root}
    plug AuthPlug, %{auth_url: "https://dwylauth.herokuapp.com"}
    plug SmartHomeAuthWeb.UserMapper
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :fetch_session # Allows us to use cookie-based authentication - do we actually need to support this?
    plug AuthPlug, %{auth_url: "https://dwylauth.herokuapp.com"}
    plug SmartHomeAuthWeb.UserMapper
  end

  scope "/", SmartHomeAuthWeb do
    pipe_through :browser

    live "/", IndexLive
    resources "/locks", DoorController, except: [:new, :edit]
    resources "/users", UserController
    resources "/devices", DeviceController, except: [:new]
    get "/access/:id", AccessController, :show
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
