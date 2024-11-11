defmodule Dynamic.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true
      add :user_id, :uuid, null: false
      add :role_id, :uuid, null: false

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create index(:user_roles, [:user_id])
    create index(:user_roles, [:role_id])

  end

  def down do
    drop table(:user_roles)
  end
end
