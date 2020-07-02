defmodule SmartHomeAuth.Repo.Migrations.AddDeviceName do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      add :name, :string
    end
  end
end
