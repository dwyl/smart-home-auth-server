defmodule SmartHomeAuth.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :rights, references(:doors, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:rights])
    create unique_index(:users, [:email])
  end
end
