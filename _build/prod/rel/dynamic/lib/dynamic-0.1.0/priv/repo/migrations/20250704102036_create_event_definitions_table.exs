defmodule Dynamic.Repo.Migrations.CreateEventDefinitionsTable do
   use Ecto.Migration

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:event_definitions,  options: "INHERITS (base)") do
        add :name, :string
        add :slug, :string
        add :fields, :map

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create unique_index(:event_definitions, [:slug])
    create index(:event_definitions, [:name])

    permissions = %{event_definitions: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'event_definitions', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'event_definitions' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)

  end

  def down do
    drop table(:event_definitions)
    execute("DELETE FROM tables WHERE name = 'event_definitions';")
  end
end
