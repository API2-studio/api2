defmodule Dynamic.Repo.Migrations.CreateGroupRoles do
  use Ecto.Migration

  def change do
    create table(:group_roles, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true
      add :group_id, :uuid, null: false
      add :role_id, :uuid, null: false

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create index(:group_roles, [:group_id])
    create index(:group_roles, [:role_id])

  end

  def down do
    drop table(:group_roles)
  end
end
