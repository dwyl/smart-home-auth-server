defmodule SmartHomeAuth.AccountTest do
  use SmartHomeAuth.DataCase

  alias SmartHomeAuth.Account

  @account_valid_attrs %{email: "bob@example.com"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@account_valid_attrs)
      |> Account.create_user()

    user
  end

  describe "users" do
    alias SmartHomeAuth.Account.User


    @update_attrs %{email: "alice@example.com"}
    @invalid_attrs %{email: nil}



    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@account_valid_attrs)
      assert user.email == "bob@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.email == @update_attrs.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "devices" do
    alias SmartHomeAuth.Account.Device

    @valid_attrs %{secret: "some secret", type: "some type", name: "example phone"}
    @update_attrs %{secret: "some updated secret", name: "new phone"}
    @invalid_attrs %{secret: nil, type: nil}

    def device_fixture(attrs \\ %{}) do
      user = user_fixture()
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, device} = Account.create_device(user, attrs)

      device
    end

    test "list_user_devices/1 returns all devices" do
      user = user_fixture()
      {:ok, device} = Account.create_device(user, @valid_attrs)
      device_uuid = Account.list_user_devices(user)
        |> List.first()
        |> Map.get(:uuid)
      assert device_uuid == device.uuid
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Account.get_device!(device.uuid).uuid == device.uuid
    end

    test "create_device/1 with valid data creates a device" do
      user = user_fixture()
      assert {:ok, %Device{} = device} = Account.create_device(user, @valid_attrs)
      assert device.secret == "some secret"
      assert device.type == "some type"
    end

    test "create_device/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.create_device(user, @invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = Account.update_device(device, @update_attrs)
      assert device.secret == "some updated secret"
      assert device.name == "new phone"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_device(device, @invalid_attrs)
      assert device.name == Account.get_device!(device.uuid).name
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Account.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Account.get_device!(device.uuid) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Account.change_device(device)
    end
  end
end
