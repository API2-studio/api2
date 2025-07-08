defmodule Dynamic.Repo.Migrations.CreateTriggersTable do
  use Ecto.Migration

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:triggers,  options: "INHERITS (base)") do
      add :event_source, :string
      add :table_name, :string
      add :event_type, :string
      add :workflow_id, references(:workflows, on_delete: :delete_all)

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create unique_index(:triggers, [:event_source, :table_name, :event_type, :workflow_id])
    create index(:triggers, [:workflow_id])
    create index(:triggers, [:event_source])
    create index(:triggers, [:table_name])
    create index(:triggers, [:event_type])

    permissions = %{triggers: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'triggers', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'triggers' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)

  end

  def down do
    drop table(:triggers)
    execute("DELETE FROM tables WHERE name = 'triggers';")
  end

end
