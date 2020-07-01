defmodule SmartHomeAuthWeb.DeviceView do
  use SmartHomeAuthWeb, :view
  alias SmartHomeAuthWeb.DeviceView

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, DeviceView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, DeviceView, "device.json")}
  end

  def render("device.json", %{device: device}) do
    %{id: device.id,
      type: device.type,
      secret: device.secret}
  end
end
