defmodule SmartHomeAuth.Repo.Migrations.AddSerialField do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      add :serial, :string
    end

    create unique_index(:devices, :serial)
  end
end
