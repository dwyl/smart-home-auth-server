defmodule SmartHomeAuth.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.Device
  alias SmartHomeAuth.Access.Door

  @derive {Jason.Encoder, only: [:email, :id]}

  schema "users" do
    field :email, :string
    field :roles, {:array, :integer}

    has_many :devices, Device

    many_to_many :doors, Door,
      join_through: "keyholders",
      join_keys: [user_id: :id, door_uuid: :uuid]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
