defmodule SmartHomeAuth.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.Device

  schema "users" do
    field :email, :string
    field :rights, :id

    has_many :devices, Device

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
