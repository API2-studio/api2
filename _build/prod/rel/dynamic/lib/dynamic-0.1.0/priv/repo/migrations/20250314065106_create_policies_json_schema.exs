defmodule Dynamic.Repo.Migrations.CreatePoliciesJsonSchema do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler

  def change do
    # Create the policies_json_schema tables
    policies_table = BaseStructures.get_table_from_name!("policies")

    # Update tables table with endpoints json schema

    execute("""
      UPDATE tables
      SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(policies_table))}'
      WHERE name = 'policies';
    """)
  end
end
