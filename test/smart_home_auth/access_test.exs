defmodule SmartHomeAuth.AccessTest do
  use SmartHomeAuth.DataCase

  alias SmartHomeAuth.Access

  describe "doors" do
    alias SmartHomeAuth.Access.Door

    @update_attrs %{name: "some updated name", type: 2}
    @invalid_attrs %{serial: nil}


    test "list_doors/0 returns all doors" do
      door = fixture(:door)
      assert Access.list_doors() == [door]
    end

    test "get_door!/1 returns the door with given id" do
      door = fixture(:door)
      assert Access.get_door!(door.uuid).uuid == door.uuid
    end

    test "create_door/1 with valid data creates a door" do
      attrs = @update_attrs
        |> Map.put(:serial, "lock-9999")
        |> Map.put(:name, "some name")
        |> Map.put(:feature_flags, [])

      assert {:ok, %Door{} = door} = Access.create_door(attrs)
      assert door.name == "some name"
      assert door.type == 2
    end

    test "create_door/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Access.create_door(@invalid_attrs)
    end

    test "update_door/2 with valid data updates the door" do
      door = fixture(:door)
      assert {:ok, %Door{} = door} = Access.update_door(door, @update_attrs)
      assert door.name == "some updated name"
      assert door.type == 2
    end

    test "update_door/2 with invalid data returns error changeset" do
      door = fixture(:door)
      assert {:error, %Ecto.Changeset{}} = Access.update_door(door, @invalid_attrs)
      assert door.name == Access.get_door!(door.uuid).name
    end

    test "delete_door/1 deletes the door" do
      door = fixture(:door)
      assert {:ok, %Door{}} = Access.delete_door(door)
      assert_raise Ecto.NoResultsError, fn -> Access.get_door!(door.uuid) end
    end

    test "change_door/1 returns a door changeset" do
      door = fixture(:door)
      assert %Ecto.Changeset{} = Access.change_door(door)
    end
  end
end
