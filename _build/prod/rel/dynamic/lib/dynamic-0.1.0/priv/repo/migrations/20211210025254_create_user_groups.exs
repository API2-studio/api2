defmodule Dynamic.Repo.Migrations.CreateUserGroups do
  use Ecto.Migration

  def change do
    create table(:user_groups, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true
      add :user_id, :uuid, null: false
      add :group_id, :uuid, null: false

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create index(:user_groups, [:user_id])
    create index(:user_groups, [:group_id])
  end

  def down do
    drop table(:user_groups)
  end
end
