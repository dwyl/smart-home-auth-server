defmodule SmartHomeAuthWeb.LockChannelTest do
  use SmartHomeAuthWeb.ChannelCase

  setup do
    serial = "lock-1234"

    lock = fixture(:door)

    {:ok, _, socket} =
      SmartHomeAuthWeb.UserSocket
      |> socket("user_id", %{name: "lock-1234"})
      |> subscribe_and_join(SmartHomeAuthWeb.LockChannel, "lock:" <> serial)
    %{socket: socket, lock: lock}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
