defmodule Dynamic.Repo.Migrations.CreateGroupRoles do
  use Ecto.Migration

  def change do
    create table(:group_roles, options: "INHERITS (base)") do
      # add :id, :uuid, null: false, autogenerate: true
      add :group_id, :uuid, null: false
      add :role_id, :uuid, null: false

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    # create unique_index(:group_roles, [:id])
    create unique_index(:group_roles, [:group_id, :role_id])
    create index(:group_roles, [:group_id])
    create index(:group_roles, [:role_id])
    create index(:group_roles, [:inserted_at])
    create index(:group_roles, [:updated_at])
    create index(:group_roles, [:deleted_at])
    create index(:group_roles, [:archived_at])

  end

  def down do
    drop table(:group_roles)
  end
end
