defmodule SmartHomeAuth.Repo.Migrations.AddRolesDoors do
  use Ecto.Migration

  def change do
    alter table(:doors) do
      add :roles, {:array, :integer}
    end
  end
end
