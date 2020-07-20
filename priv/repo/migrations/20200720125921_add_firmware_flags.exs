defmodule SmartHomeAuth.Repo.Migrations.AddFirmwareFlags do
  use Ecto.Migration

  def change do
    alter table(:doors) do
      add :feature_flags, {:array, :string}
    end
  end
end
