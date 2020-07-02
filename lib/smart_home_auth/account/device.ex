defmodule SmartHomeAuth.Account.Device do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.User

  schema "devices" do
    field :secret, :string
    field :type, :string
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:type, :secret, :name])
    |> validate_required([:type, :secret, :name])
  end
end
