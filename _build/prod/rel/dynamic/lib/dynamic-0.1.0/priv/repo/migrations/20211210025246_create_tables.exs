defmodule Dynamic.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables, options: "INHERITS (base)") do
      # add :id, :uuid, null: false, autogenerate: true
      add :created_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :updated_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :name, :string
      add :parent, :string
      add :permissions, :map
      add :schema, :map
      add :json_schema, :map
      add :json_schema_ui, :map
      add :relations, :map
      add :searchable, :boolean, default: false
      add :acl_default, :map, default: %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    create unique_index(:tables, [:name])
    create index(:tables, [:parent])
    create index(:tables, [:created_by])
    create index(:tables, [:updated_by])
    create index(:tables, [:searchable])


  end

  def down do
    drop table(:tables)
  end
end
