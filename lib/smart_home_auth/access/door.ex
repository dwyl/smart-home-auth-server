defmodule SmartHomeAuth.Access.Door do
  @moduledoc """
  Defines the schema for a simple door.

  `Name`: The name of the door
  `Type`: The type of the door
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

    many_to_many :users, User,
      join_through: "keyholders",
      join_keys: [door_uuid: :uuid, user_id: :id]

    timestamps()
  end

  @doc false
  def changeset(door, attrs) do
    door
    |> cast(attrs, [:name, :type, :serial])
    |> validate_required([:serial])
  end

end
