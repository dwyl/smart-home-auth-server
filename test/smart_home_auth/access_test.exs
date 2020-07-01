defmodule SmartHomeAuth.AccessTest do
  use SmartHomeAuth.DataCase

  alias SmartHomeAuth.Access

  describe "doors" do
    alias SmartHomeAuth.Access.Door

    @valid_attrs %{name: "some name", type: 42}
    @update_attrs %{name: "some updated name", type: 43}
    @invalid_attrs %{name: nil, type: nil}

    def door_fixture(attrs \\ %{}) do
      {:ok, door} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Access.create_door()

      door
    end

    test "list_doors/0 returns all doors" do
      door = door_fixture()
      assert Access.list_doors() == [door]
    end

    test "get_door!/1 returns the door with given id" do
      door = door_fixture()
      assert Access.get_door!(door.id) == door
    end

    test "create_door/1 with valid data creates a door" do
      assert {:ok, %Door{} = door} = Access.create_door(@valid_attrs)
      assert door.name == "some name"
      assert door.type == 42
    end

    test "create_door/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Access.create_door(@invalid_attrs)
    end

    test "update_door/2 with valid data updates the door" do
      door = door_fixture()
      assert {:ok, %Door{} = door} = Access.update_door(door, @update_attrs)
      assert door.name == "some updated name"
      assert door.type == 43
    end

    test "update_door/2 with invalid data returns error changeset" do
      door = door_fixture()
      assert {:error, %Ecto.Changeset{}} = Access.update_door(door, @invalid_attrs)
      assert door == Access.get_door!(door.id)
    end

    test "delete_door/1 deletes the door" do
      door = door_fixture()
      assert {:ok, %Door{}} = Access.delete_door(door)
      assert_raise Ecto.NoResultsError, fn -> Access.get_door!(door.id) end
    end

    test "change_door/1 returns a door changeset" do
      door = door_fixture()
      assert %Ecto.Changeset{} = Access.change_door(door)
    end
  end
end
