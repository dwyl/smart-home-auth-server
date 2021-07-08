defmodule SmartHomeAuth.Repo.Migrations.AddRolesField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :roles, {:array, :integer}
    end
  end
end
