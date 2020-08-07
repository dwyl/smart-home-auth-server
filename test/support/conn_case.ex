defmodule SmartHomeAuthWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use SmartHomeAuthWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import SmartHomeAuthWeb.ConnCase

      import SmartHomeAuth.TestHelpers

      alias SmartHomeAuthWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint SmartHomeAuthWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SmartHomeAuth.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(SmartHomeAuth.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()
      |> Phoenix.ConnTest.init_test_session(%{})
      |> AuthPlug.create_jwt_session(%{email: "bob@example.com", id: 1})

    {:ok, conn: conn}
  end
end
