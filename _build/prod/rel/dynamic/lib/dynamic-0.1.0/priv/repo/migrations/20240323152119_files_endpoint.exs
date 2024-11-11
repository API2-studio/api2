defmodule Dynamic.Repo.Migrations.FilesEndpoint do
  use Ecto.Migration
  alias Dynamic.Utils
  alias Dynamic.BaseStructures
  alias Dynamic.JsonSchemaCompiler
  alias Dynamic.Docs.JsonSchemaCompiler
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:files, primary_key: false, options: "INHERITS (base)") do
      add(:id, :uuid, null: false, autogenerate: true)
      add(:name, :string, null: false)
      add(:file, :string, null: false)
      add(:type, :string, null: false)

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create(unique_index(:files, [:id]))
    create(unique_index(:files, [:name]))

    permissions = %{ files: [:create, :read, :update, :delete] }

    # Add files to the tables table
    execute("""
      INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'files', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'files' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, NULL);
    """)

    # Add permissions to the permissions table
    execute("""
      UPDATE tables
      SET permissions = '#{Jason.encode!(permissions)}'
      WHERE name = 'files';
    """)
  end

  def down do
    drop table(:files)
    execute("DELETE FROM tables WHERE name = 'files';")
  end
end
