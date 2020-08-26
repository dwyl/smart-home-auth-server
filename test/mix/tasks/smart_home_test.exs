defmodule Mix.Tasks.SmartHomeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @jwt_pattern ~r/[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+\/=]*$/m

  test "Mix task returns a valid JWT" do
    out = capture_io(fn -> Mix.Tasks.SmartHome.GenToken.run([]) end)

    jwt = Regex.run(@jwt_pattern, out) |> List.first()

    decoded = AuthPlug.Token.verify_jwt!(jwt)
    assert %{"id" => 1} = decoded
  end
end
