defmodule Dynamic.Repo.Migrations.CreateTriggersJsonSchema do
  use Ecto.Migration
    alias Dynamic.BaseStructures
    alias Dynamic.Docs.JsonSchemaCompiler
  def change do
    # Create the triggers_json_schema tables
    triggers_table = BaseStructures.get_table_from_name!("triggers")

    # Update tables table with endpoints json schema

    execute("""
      UPDATE tables
      SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(triggers_table))}'
      WHERE name = 'triggers';
    """)
  end
end
