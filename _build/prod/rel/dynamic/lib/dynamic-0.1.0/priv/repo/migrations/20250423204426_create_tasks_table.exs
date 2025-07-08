defmodule Dynamic.Repo.Migrations.CreateTasksTable do
  use Ecto.Migration

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    create table(:tasks,  options: "INHERITS (base)") do

      add(:name, :string, null: false)
      add(:action, :string, null: false)
      add(:condition, :string)
      add(:initial, :boolean, null: false)
      add(:next_task_id, :uuid, null: true)
      add(:previous_task_id, :uuid, null: true)
      add(:workflow_id, :uuid, null: true)
      add(:on_true_id, :uuid, null: true)
      add(:on_false_id, :uuid, null: true)
      add(:action_data, :map, null: true)

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    # create unique_index(:policies, [:id])
    create unique_index(:tasks, [:workflow_id, :name])

    permissions = %{tasks: [:create, :read, :update, :delete]}
    acl_default = %{roles: [], users: [], groups: [], match_all: false, match_any: false, match_none: true}

    execute("""
     INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable, acl_default)
     VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'tasks', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'tasks' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, '#{Jason.encode!(permissions)}', false, '#{Jason.encode!(acl_default)}');
    """)

  end

  def down do
    drop table(:tasks)
    execute("DELETE FROM tables WHERE name = 'tasks';")
  end

end
