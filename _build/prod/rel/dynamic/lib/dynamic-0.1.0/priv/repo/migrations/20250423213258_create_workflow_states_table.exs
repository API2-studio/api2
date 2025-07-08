defmodule Dynamic.Repo.Migrations.CreateWorkflowStatesTable do
  use Ecto.Migration

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()
  def change do
    create table(:workflow_states,  options: "INHERITS (base)") do

      add(:workflow_id, :uuid, null: false)
      add(:task_id, :uuid, null: false)
      add(:state, :string, null: false)
      add(:started_at, :utc_datetime)
      add(:completed_at, :utc_datetime)


      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    # create unique_index(:policies, [:id])


    permissions = %{workflow_states: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    execute("""
     INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
     VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'workflow_states', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'workflow_states' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)
  end

  def down do
    drop table(:workflow_states)
    execute("DELETE FROM tables WHERE name = 'workflow_states';")
  end
end
