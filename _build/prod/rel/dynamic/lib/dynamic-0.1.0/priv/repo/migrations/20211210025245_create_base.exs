defmodule Dynamic.Repo.Migrations.CreateBase do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS pgcrypto;")

    execute("SET timezone TO 'UTC';")

    create table(:base, primary_key: false) do
      add :id, :uuid, null: false
      add :acl, :map, null: false, default: %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}
      add :archived_at, :timestamptz
      add :deleted_at, :timestamptz
      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create unique_index(:base, [:id])
  end

  def down do
    drop table(:base)
  end
end
