defmodule Dynamic.Repo.Migrations.CreateWorkflowStatesJsonSchema do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler

  def change do
       # Create the policies_json_schema tables
       workflow_states_table = BaseStructures.get_table_from_name!("workflow_states")

       # Update tables table with endpoints json schema

       execute("""
         UPDATE tables
         SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(workflow_states_table))}'
         WHERE name = 'workflow_states';
       """)
  end
end
