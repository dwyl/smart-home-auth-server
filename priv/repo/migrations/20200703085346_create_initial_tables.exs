defmodule SmartHomeAuth.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def change do
    create table(:doors, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :type, :integer

      timestamps()
    end

    create table(:users) do
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:devices, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :secret, :string
      add :name, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create table(:keyholders, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :door_uuid, references(:doors, on_delete: :delete_all,
        type: :uuid, column: :uuid)
    end
  end
end
