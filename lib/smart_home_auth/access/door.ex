defmodule SmartHomeAuth.Access.Door do
  @moduledoc """
  Defines the schema for nodes that connect to the hub

  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SmartHomeAuth.Account.User

  @primary_key {:uuid, Ecto.UUID, autogenerate: :true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :uuid}
  @derive {Jason.Encoder, only: [:serial]}

  schema "doors" do
    field :name, :string
    field :type, :integer
    field :serial, :string
    field :feature_flags, {:array, :string}

    # Config should be used to store data associated with feature_flags.
    # Any relationship data should be in a new field instead.
    # This will be passed to the devices themselves to read
    field :config, :map

    many_to_many :users, User,
      join_through: "keyholders",
      join_keys: [door_uuid: :uuid, user_id: :id]

    timestamps()
  end

  @doc false
  def changeset(door, attrs) do
    door
    |> cast(attrs, [:name, :type, :serial, :feature_flags, :config])
    |> validate_required([:serial, :feature_flags])
  end

end
