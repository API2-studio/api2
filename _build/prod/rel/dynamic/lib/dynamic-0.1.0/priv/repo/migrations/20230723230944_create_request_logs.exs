defmodule Dynamic.Repo.Migrations.CreateRequestLogs do
  alias Dynamic.Utils
  alias Dynamic.BaseStructures
  use Ecto.Migration
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:request_logs, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true
      add :method, :string
      add :path, :string
      add :headers, :map

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create unique_index(:request_logs, [:id])

    permissions = %{ request_logs: [:create, :read, :update, :delete] }

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'request_logs', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'request_logs' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, NULL, false);
    """)

    # Update the permissions for the request_logs table

    execute("""
    UPDATE tables
      SET permissions = '#{Jason.encode!(permissions)}'
      WHERE name = 'request_logs';
    """)

  end

  def down do
    drop table(:request_logs)
  end
end
