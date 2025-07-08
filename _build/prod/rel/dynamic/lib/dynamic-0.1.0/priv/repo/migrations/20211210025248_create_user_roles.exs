defmodule Dynamic.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles, options: "INHERITS (base)") do
      # add :id, :uuid, null: false, autogenerate: true
      add :user_id, :uuid, null: false
      add :role_id, :uuid, null: false

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    # create unique_index(:user_roles, [:id])
    create unique_index(:user_roles, [:user_id, :role_id])
    create index(:user_roles, [:user_id])
    create index(:user_roles, [:role_id])
    create index(:user_roles, [:inserted_at])
    create index(:user_roles, [:updated_at])
    create index(:user_roles, [:deleted_at])
    create index(:user_roles, [:archived_at])

  end

  def down do
    drop table(:user_roles)
  end
end
