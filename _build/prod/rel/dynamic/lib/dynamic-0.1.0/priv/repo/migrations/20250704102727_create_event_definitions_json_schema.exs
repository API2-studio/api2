defmodule Dynamic.Repo.Migrations.CreateEventDefinitionsJsonSchema do
   use Ecto.Migration
    alias Dynamic.BaseStructures
    alias Dynamic.Docs.JsonSchemaCompiler
  def change do
    # Create the triggers_json_schema tables
    event_definitions_table = BaseStructures.get_table_from_name!("event_definitions")

    # Update tables table with endpoints json schema

    execute("""
      UPDATE tables
      SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(event_definitions_table))}'
      WHERE name = 'event_definitions';
    """)
  end
end
