defmodule Dynamic.Repo.Migrations.FilesMetaData do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Docs.JsonSchemaCompiler

  def change do

    # Generate json_schema for files
    files_table = BaseStructures.get_table_from_name!("files")
    files_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(files_table))

    execute("""
      UPDATE tables SET json_schema = '#{files_json_schema}' WHERE name = 'files';
    """)
  end

  def down do
    execute("""
      UPDATE tables SET json_schema = NULL WHERE name = 'files';
    """)
  end
end
