defmodule Dynamic.Repo.Migrations.CreateConfigsTable do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:configs, primary_key: false, options: "INHERITS (base)") do
      add(:id, :uuid, null: false, autogenerate: true)
      add(:application, :string, null: false)
      add(:key, :string, null: false)
      add(:value, :map, null: true, default: nil)

      timestamps(type: :timestamptz, extended: true, abbrev: true)
    end

    create(unique_index(:configs, [:id]))
    create(unique_index(:configs, [:application, :key]))


    permissions = %{configs: [:create, :read, :update, :delete]}

    # Add configs to the tables table

    execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'configs', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'configs' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, NULL);
    """)

    # Add permissions to the permissions table

    execute("""
      UPDATE tables
      SET permissions = '#{Jason.encode!(permissions)}'
      WHERE name = 'configs';
    """)
  end

  def down do
    drop(table(:configs))
    execute("DELETE FROM tables WHERE name = 'configs';")
  end
end
