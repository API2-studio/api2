defmodule Dynamic.Repo.Migrations.CreateWorkflowsJsonSchema do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler

  def change do
       # Create the policies_json_schema tables
       workflows_table = BaseStructures.get_table_from_name!("workflows")

       # Update tables table with endpoints json schema

       execute("""
         UPDATE tables
         SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(workflows_table))}'
         WHERE name = 'workflows';
       """)
  end
end
