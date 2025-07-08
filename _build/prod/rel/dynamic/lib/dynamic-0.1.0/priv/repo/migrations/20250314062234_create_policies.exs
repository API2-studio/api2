defmodule Dynamic.Repo.Migrations.CreatePolicies do
  use Ecto.Migration
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:policies,  options: "INHERITS (base)") do
      # add(:id, :uuid, null: false, autogenerate: true)
      add :table_id, :uuid, null: false
      add :acl_override, :map, default: %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}
      add :name, :string, null: false
      add :description, :string
      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    # create unique_index(:policies, [:id])
    create unique_index(:policies, [:table_id])
    create unique_index(:policies, [:name])

    permissions = %{policies: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    execute("""
     INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
     VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'policies', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'policies' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)
  end

  def down do
    drop table(:policies)
    execute("DELETE FROM tables WHERE name = 'policies';")
  end
end
