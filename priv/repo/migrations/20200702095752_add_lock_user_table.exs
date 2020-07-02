defmodule SmartHomeAuth.Repo.Migrations.AddLockUserTable do
  use Ecto.Migration

  def change do
    create table(:keyholders, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing)
      add :door_id, references(:doors, on_delete: :nothing)
    end

    create index(:keyholders, [:user_id, :door_id])

    # Disregard previous relationship attempt
    drop index(:users, [:rights])

    alter table(:users) do
      remove(:rights)
    end

  end
end
