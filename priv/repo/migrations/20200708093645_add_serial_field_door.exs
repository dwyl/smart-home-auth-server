defmodule SmartHomeAuth.Repo.Migrations.AddSerialFieldDoor do
  use Ecto.Migration

  def change do
    alter table(:doors) do
      add :serial, :string
    end

    create unique_index(:doors, :serial)
  end
end
