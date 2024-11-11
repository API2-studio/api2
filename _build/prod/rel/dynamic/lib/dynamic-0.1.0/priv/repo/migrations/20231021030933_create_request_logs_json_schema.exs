defmodule Dynamic.Repo.Migrations.CreateRequestLogsJsonSchema do
  alias Dynamic.BaseStructures
  alias Dynamic.Utils
  alias Dynamic.Docs.JsonSchemaCompiler
  use Ecto.Migration

  def change do
        # Update the json schema for the request_logs table

        request_logs_table = BaseStructures.get_table_from_name!("request_logs")
        request_logs_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(request_logs_table))

        execute("""
        UPDATE tables SET json_schema = '#{request_logs_json_schema}' WHERE name = 'request_logs';
        """)
  end

  def down do
    execute("""
    UPDATE tables
      SET json_schema = NULL
      WHERE name = 'request_logs';
    """)
  end
end
