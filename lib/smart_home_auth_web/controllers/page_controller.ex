defmodule SmartHomeAuthWeb.PageController do
  use SmartHomeAuthWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
