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
    %{uuid: device.uuid,
      type: device.type,
      name: device.name,
      serial: device.serial
    }
  end

  def pairing_device_select_options(locks) do
    for l <- locks, do: {l.name, l.serial}
  end
end
