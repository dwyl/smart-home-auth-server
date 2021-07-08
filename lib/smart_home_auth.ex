defmodule SmartHomeAuth do
  @moduledoc """
  SmartHomeAuth keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.

  """

  @doc """
  Generate a local-use authentication token for API development.
  """
  @spec gen_auth_token :: binary
  def gen_auth_token do
    AuthPlug.Token.generate_jwt!(
      %{
        "id" => 1,
        "email" => "test@example.com",
        "auth_provider" => "local-dev",
        "givenName" => "Dev Superuser",
        "roles" => "1,2,3"
      })
  end
end
