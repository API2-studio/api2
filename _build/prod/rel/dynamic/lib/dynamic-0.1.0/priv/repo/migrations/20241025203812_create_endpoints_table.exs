defmodule Dynamic.Repo.Migrations.CreateEndpointsTable do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:endpoints, options: "INHERITS (base)") do
      # add(:id, :uuid, null: false, autogenerate: true)
      add(:url, :string, null: false)
      add(:method, :string, null: false)
      add(:json_schema, :map, null: false)
      add(:query, :map, null: true, default: nil)
      add(:source_table_id, :uuid, null: true, default: nil)
      add(:response_template, :map, null: true, default: nil)
      add(:auth_required, :boolean, null: false, default: false)
      add(:rate_limit, :integer, null: true, default: nil)
      add(:enabled, :boolean, null: false, default: true)
      add(:description, :string, null: true, default: nil)
      add(:query_params_schema, :map, null: true, default: nil)
      add(:url_params_schema, :map, null: true, default: nil)
      add(:body_params_schema, :map, null: true, default: nil)
      add(:permissions, :map, null: true, default: nil)

      timestamps(type: :timestamptz, extended: true, abbrev: true)
    end

    create unique_index(:endpoints, [:url, :method])
    create index(:endpoints, [:url, :method, :enabled])
    create index(:endpoints, [:source_table_id])
    create index(:endpoints, [:enabled])
    create index(:endpoints, [:auth_required])
    create index(:endpoints, [:rate_limit])
    create index(:endpoints, [:inserted_at])
    create index(:endpoints, [:updated_at])
    create index(:endpoints, [:deleted_at])
    create index(:endpoints, [:archived_at])


    permissions = %{endpoints: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    # Add endpoints to the tables table

    execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'endpoints', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'endpoints' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)

  end

  def down do
    drop(table(:endpoints))
    execute("DELETE FROM tables WHERE name = 'endpoints';")
  end
end
