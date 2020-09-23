defmodule SmartHomeAuth.Access do
  @moduledoc """
  The Access context.
  """

  import Ecto.Query, warn: false
  alias SmartHomeAuth.Repo

  alias SmartHomeAuth.Access.Door
  alias SmartHomeAuth.Account.User

  @doc """
  Returns the list of doors.

  ## Examples

      iex> list_doors()
      [%Door{}, ...]

  """
  def list_doors do
    Repo.all(Door)
  end

  @doc """
  Gets a single door.

  Raises `Ecto.NoResultsError` if the Door does not exist.

  ## Examples

      iex> get_door!(123)
      %Door{}

      iex> get_door!(456)
      ** (Ecto.NoResultsError)

  """
  def get_door!(id) do
    Repo.get!(Door, id)
    |> Repo.preload(:users)
  end

  def get_door_by_serial(serial) do
    Repo.get_by(Door, serial: serial)
  end

  @doc """
  Creates a door.

  ## Examples

      iex> create_door(%{field: value})
      {:ok, %Door{}}

      iex> create_door(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_door(attrs \\ %{}) do
    %Door{}
    |> Door.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a door.

  ## Examples

      iex> update_door(door, %{field: new_value})
      {:ok, %Door{}}

      iex> update_door(door, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_door(%Door{} = door, attrs) do

    door
    |> Door.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a door.

  ## Examples

      iex> delete_door(door)
      {:ok, %Door{}}

      iex> delete_door(door)
      {:error, %Ecto.Changeset{}}

  """
  def delete_door(%Door{} = door) do
    Repo.delete(door)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking door changes.

  ## Examples

      iex> change_door(door)
      %Ecto.Changeset{data: %Door{}}

  """
  def change_door(%Door{} = door, attrs \\ %{}) do
    Door.changeset(door, attrs)
  end

  def check?(%Door{} = door, %User{} = user) do
    q =
      from d in Door,
        join: kh in "keyholders", on: kh.door_uuid == type(^door.uuid, Ecto.UUID),
        where: kh.user_id == ^user.id

    Repo.exists?(q)
  end

  def check?(_door, nil) do
    false
  end

  @doc """
  Returns a list of all availiable feature flags
  """
  def all_flags do
    ["display", "lock"]
  end
end
