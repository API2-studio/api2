defmodule Dynamic.Repo.Migrations.CreateWebhooksTable do
   use Ecto.Migration

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:webhooks,  options: "INHERITS (base)") do
        add :name, :string
        add :event_slug, :string
        add :target_url, :string
        add :headers, :map
        add :template, :string
        add :condition, :map

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create unique_index(:webhooks, [:event_slug, :target_url])
    create index(:webhooks, [:name])
    create index(:webhooks, [:event_slug])
    create index(:webhooks, [:target_url])

    permissions = %{webhooks: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'webhooks', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'webhooks' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)

  end

  def down do
    drop table(:webhooks)
    execute("DELETE FROM tables WHERE name = 'webhooks';")
  end
end
