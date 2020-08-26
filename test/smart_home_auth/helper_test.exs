defmodule SmartHomeAuth.HelperTest do
  use ExUnit.Case, async: true

  test "gen_auth_token generates a correct token" do
    token = SmartHomeAuth.gen_auth_token()

    decoded = AuthPlug.Token.verify_jwt!(token)

    assert %{"id" => 1} = decoded
  end
end
