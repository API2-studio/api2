defmodule Dynamic.Repo.Migrations.CreateEndpointsJsonSchema do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    # Create the endpoints_json_schema table
    endpoints_table = BaseStructures.get_table_from_name!("endpoints")

    # Update tables table with endpoints json schema

    execute("""
      UPDATE tables
      SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(endpoints_table))}'
      WHERE name = 'endpoints';
    """)
  end
end
