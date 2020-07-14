defmodule SmartHomeAuth.Account.Device do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.User

  @primary_key {:uuid, Ecto.UUID, autogenerate: :true}
  @derive {Phoenix.Param, key: :uuid}
  @derive {Jason.Encoder, only: [:name, :type, :serial]}

  schema "devices" do
    # The name of the device, e.g. "My iPhone"
    field :name, :string

    # A shared secret for "smart" devices that is used
    # to validate 2FA requests - could be binary?
    field :secret, :string

    # The type of the device - should be either
    # - mobile_phone
    # - tag
    field :type, :string

    # Used to store serial numbers of NFC tags
    field :serial, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:type, :secret, :name, :serial])
    |> validate_required([:type, :name])
  end

  def change_pair(pair, attrs) do
    types = %{lock: :string, name: :string, type: :string}

    {pair, types}
    |> cast(attrs, Map.keys(types))
    |> validate_required(Map.keys(types))
  end
end
