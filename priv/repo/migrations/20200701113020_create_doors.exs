defmodule SmartHomeAuth.Repo.Migrations.CreateDoors do
  use Ecto.Migration

  def change do
    create table(:doors) do
      add :name, :string
      add :type, :integer

      timestamps()
    end

  end
end
