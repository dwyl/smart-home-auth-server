defmodule SmartHomeAuthWeb.Router do
  use SmartHomeAuthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :fetch_session # Allows us to use cookie-based authentication - do we actually need to support this?
    plug AuthPlug, %{auth_url: "https://dwylauth.herokuapp.com"}
    plug SmartHomeAuthWeb.UserMapper
  end

  scope "/api/v0", SmartHomeAuthWeb do
    pipe_through :api

    get "/access/:id", AccessController, :show
  end

  scope "/api/v0", SmartHomeAuthWeb do
    pipe_through :api
    pipe_through :auth

    resources "/locks", DoorController, except: [:new, :edit] # Need to refractor doors to locks
    resources "/users", UserController, except: [:new, :edit, :create, :update]
    resources "/devices", DeviceController, except: [:new, :edit]

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
