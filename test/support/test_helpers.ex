defmodule SmartHomeAuthWeb.TestHelpers do

  alias SmartHomeAuth.Account
  alias SmartHomeAuth.Access


  @device_create_attrs %{
    secret: "some secret",
    name: "iPhone",
    type: "mobile_phone"
  }

  @door_create_attrs %{
    name: "some name",
    type: 1
  }

  def fixture(:user) do
    {:ok, user} = Account.create_user(%{email: "test@example.com"})
    user
  end

  def fixture(:device) do
    {:ok, device} = Account.create_device(fixture(:user), @device_create_attrs)
    device
  end

  def fixture(:door) do
    {:ok, door} = Access.create_door(@door_create_attrs)
    door
  end

  def fixture(:device, user) do
    {:ok, device} = Account.create_device(user, @device_create_attrs)
    device
  end

end
