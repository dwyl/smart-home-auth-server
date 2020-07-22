defmodule SmartHomeAuth.Repo.Migrations.AddConfigField do
  use Ecto.Migration

  def change do
    alter table(:doors) do
      add :config, :map
    end
  end
end
