defmodule Dynamic.Repo.Migrations.CreateTriggersRelations do
  use Ecto.Migration
  alias Dynamic.Utils

  def change do
    triggers_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "triggers_workflow_id",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflows")),
          "name" => "workflows"
        },
        "table" => %{
          "column" => "workflow_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("triggers")),
          "name" => "triggers"
        },
        "through_table" => nil
      }
    ]

    workflow_relations = [
      %{
        "relation_type" => "one-to-many",
        "relation_name" => "triggers",
        "references_table" => %{
          "column" => "workflow_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("triggers")),
          "name" => "triggers"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflows")),
          "name" => "workflows"
        },
        "through_table" => nil
      },
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
      SET relations = '#{Jason.encode!(triggers_relations)}'
      WHERE name = 'triggers';
    """)

    execute("""
      UPDATE tables
      SET relations = '#{Jason.encode!(workflow_relations)}'
      WHERE name = 'workflows';
    """)
  end
end
