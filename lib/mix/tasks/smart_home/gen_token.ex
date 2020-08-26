defmodule Mix.Tasks.SmartHome.GenToken do
  use Mix.Task

  @shortdoc "Generate a JWT token for use with local API development"
  def run(_) do
    IO.puts("Generating JWT Token...")
    jwt = SmartHomeAuth.gen_auth_token()

    IO.puts("\n\n")
    IO.puts(jwt)
  end
end
