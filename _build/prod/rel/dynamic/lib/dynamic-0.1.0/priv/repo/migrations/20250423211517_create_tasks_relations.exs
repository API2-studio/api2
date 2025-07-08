defmodule Dynamic.Repo.Migrations.CreateTasksRelations do
  use Ecto.Migration
  alias Dynamic.Utils


  def change do

    tasks_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "workflow",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("workflows")),
          "name" => "workflows"
        },
        "table" => %{
          "column" => "workflow_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-one",
        "relation_name" => "next_task",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "table" => %{
          "column" => "next_task_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-one",
        "relation_name" => "previous_task",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "table" => %{
          "column" => "previous_task_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-one",
        "relation_name" => "on_true",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "table" => %{
          "column" => "on_true_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-one",
        "relation_name" => "on_false",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "table" => %{
          "column" => "on_false_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tasks")),
          "name" => "tasks"
        },
        "through_table" => nil
      },
    ]

    execute("""
      UPDATE tables
      SET relations = '#{Jason.encode!(tasks_relations)}'
      WHERE name = 'tasks';
    """)
  end
end
