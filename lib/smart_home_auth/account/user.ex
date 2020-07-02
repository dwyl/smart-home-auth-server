defmodule SmartHomeAuth.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.Device
  alias SmartHomeAuth.Access.Door

  schema "users" do
    field :email, :string

    has_many :devices, Device

    many_to_many :doors, Door,
      join_through: "keyholders"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
