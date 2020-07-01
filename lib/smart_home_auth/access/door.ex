defmodule SmartHomeAuth.Access.Door do
  @moduledoc """
  Defines the schema for a simple door.

  `Name`: The name of the door
  `Type`: The type of the door
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "doors" do
    field :name, :string
    field :type, :integer

    timestamps()
  end

  @doc false
  def changeset(door, attrs) do
    door
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end
end
