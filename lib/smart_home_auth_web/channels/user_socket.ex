defmodule SmartHomeAuthWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", SmartHomeAuthWeb.RoomChannel
  channel "lock:*", SmartHomeAuthWeb.LockChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  # Sockets require a unique identifier. This can be set to anything and
  # is just to indentify the client.
  #
  # We will use `name`
  @impl true
  def connect(%{"name" => name}, socket, _connect_info) do
    socket =
      socket
      |> assign(:name, name)
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     SmartHomeAuthWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.name}"
end
