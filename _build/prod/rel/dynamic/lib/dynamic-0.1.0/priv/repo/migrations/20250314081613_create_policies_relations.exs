alias Dynamic.BaseStructures
defmodule Dynamic.Repo.Migrations.CreatePoliciesRelations do
  use Ecto.Migration
  alias Dynamic.Utils

  def change do


    policies_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "policies_table_id",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tables")),
          "name" => "tables"
        },
        "table" => %{
          "column" => "table_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("policies")),
          "name" => "policies"
        },
        "through_table" => nil
      }
    ]

    tables_relations = [
      %{
        "relation_type" => "one-to-one",
        "relation_name" => "policies",
        "references_table" => %{
          "column" => "table_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("policies")),
          "name" => "policies"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("tables")),
          "name" => "tables"
        },
        "through_table" => nil
      }
    ]

    execute("""
      UPDATE tables
      SET relations = '#{Jason.encode!(policies_relations)}'
      WHERE name = 'policies';
    """)

    execute("""
      UPDATE tables
      SET relations = '#{Jason.encode!(tables_relations)}'
      WHERE name = 'tables';
    """)
  end
end
