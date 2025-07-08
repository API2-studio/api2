defmodule Dynamic.Repo.Migrations.CreateWebhooksJsonSchema do
   use Ecto.Migration
    alias Dynamic.BaseStructures
    alias Dynamic.Docs.JsonSchemaCompiler
  def change do
    # Create the triggers_json_schema tables
    webhooks_table = BaseStructures.get_table_from_name!("webhooks")

    # Update tables table with endpoints json schema

    execute("""
      UPDATE tables
      SET json_schema = '#{Jason.encode!(JsonSchemaCompiler.generate_schema(webhooks_table))}'
      WHERE name = 'webhooks';
    """)
  end
end
