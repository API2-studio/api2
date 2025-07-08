defmodule Dynamic.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:events,  options: "INHERITS (base)") do
      add(:name, :string, null: false)
      add(:payload, :map, null: false)
      add(:event_source, :string, null: false, default: "db")
      add(:table_name, :string, null: false)
      add(:event_type, :string, null: false)

      add(:archived_at, :timestamptz, extended: true, abbrev: true)
      add(:deleted_at, :timestamptz, extended: true, abbrev: true)
      add(:acl, :map)

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

     # create unique_index(:policies, [:id])
     create index(:events, [:name])

     permissions = %{events: [:create, :read, :update, :delete]}
     acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

     execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'events', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'events' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
     """)

  end

  def down do
    drop table(:events)
    execute("DELETE FROM tables WHERE name = 'events';")
  end
end
