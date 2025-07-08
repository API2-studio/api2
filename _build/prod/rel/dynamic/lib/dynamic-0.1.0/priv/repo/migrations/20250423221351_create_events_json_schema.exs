defmodule Dynamic.Repo.Migrations.CreateEventsJsonSchema do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler

  def change do
       # Create the policies_json_schema tables
       events_table = BaseStructures.get_table_from_name!("events")

       # Update tables table with endpoints json schema

       execute("""
         UPDATE tables
         SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(events_table))}'
         WHERE name = 'events';
       """)
  end
end
