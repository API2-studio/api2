defmodule Dynamic.Repo.Migrations.CreateWorkflowStatesRelations do
  use Ecto.Migration
  alias Dynamic.Utils

  def change do
    workflow_states_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "workflow_states_workflow_id",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflows")),
          "name" => "workflows"
        },
        "table" => %{
          "column" => "workflow_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflow_states")),
          "name" => "workflow_states"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "workflow_states_task_id",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "table" => %{
          "column" => "task_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflow_states")),
          "name" => "workflow_states"
        },
        "through_table" => nil
      }
    ]

    workflows_relations = [
      %{
        "relation_type" => "one-to-one",
        "relation_name" => "workflow_states",
        "references_table" => %{
          "column" => "workflow_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflow_states")),
          "name" => "workflow_states"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflows")),
          "name" => "workflows"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-many",
        "relation_name" => "tasks",
        "references_table" => %{
          "column" => "workflow_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflows")),
          "name" => "workflows"
        },
        "through_table" => nil
      }
    ]

    execute("""
      UPDATE tables
      SET relations = '#{Jason.encode!(workflow_states_relations)}'
      WHERE name = 'workflow_states';
    """)

    execute("""
      UPDATE tables
      SET relations = '#{Jason.encode!(workflows_relations)}'
      WHERE name = 'workflows';
    """)
  end
end
