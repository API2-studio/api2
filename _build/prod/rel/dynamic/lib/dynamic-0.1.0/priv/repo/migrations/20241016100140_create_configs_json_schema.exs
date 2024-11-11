defmodule Dynamic.Repo.Migrations.CreateConfigsJsonSchema do
  use Ecto.Migration

  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler
  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do
    # Create the configs_json_schema table
    configs_table = BaseStructures.get_table_from_name!("configs")

    # Update tables table with configs json schema

    execute("""
      UPDATE tables
      SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(configs_table))}'
      WHERE name = 'configs';
    """)
  end
end
