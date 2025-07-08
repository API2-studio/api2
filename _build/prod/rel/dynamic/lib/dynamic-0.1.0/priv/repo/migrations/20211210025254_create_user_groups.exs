defmodule Dynamic.Repo.Migrations.CreateUserGroups do
  use Ecto.Migration

  def change do
    create table(:user_groups, options: "INHERITS (base)") do
      # add :id, :uuid, null: false, autogenerate: true
      add :user_id, :uuid, null: false
      add :group_id, :uuid, null: false

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    # create unique_index(:user_groups, [:id])
    create unique_index(:user_groups, [:user_id, :group_id])
    create index(:user_groups, [:user_id])
    create index(:user_groups, [:group_id])
    create index(:user_groups, [:inserted_at])
    create index(:user_groups, [:updated_at])
    create index(:user_groups, [:deleted_at])
    create index(:user_groups, [:archived_at])
  end

  def down do
    drop table(:user_groups)
  end
end
