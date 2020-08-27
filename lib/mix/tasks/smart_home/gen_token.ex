defmodule Mix.Tasks.SmartHome.GenToken do
  use Mix.Task

  @shortdoc "Generate a JWT token for use with local API development"
  def run(_) do
    jwt = SmartHomeAuth.gen_auth_token()
    IO.puts(jwt)
  end
end
