defmodule SmartHomeAuth.Account.Device do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.User

  schema "devices" do
    field :secret, :string
    field :type, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:type, :secret])
    |> validate_required([:type, :secret])
  end
end
