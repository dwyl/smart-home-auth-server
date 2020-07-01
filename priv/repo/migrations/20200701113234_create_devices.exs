defmodule SmartHomeAuth.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :type, :string
      add :secret, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:devices, [:user_id])
  end
end
