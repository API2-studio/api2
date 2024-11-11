defmodule Dynamic.Repo.Migrations.UpdateRelationsForTableFunction do
  use Ecto.Migration

  def change do
    execute("""
    CREATE OR REPLACE FUNCTION update_relations_for_table() RETURNS TRIGGER AS
    $$
    DECLARE
        arg_table_id  text;
        arg_payload jsonb;
    BEGIN
        arg_table_id := TG_ARGV[0];
        arg_payload := TG_ARGV[1];
        EXECUTE format('UPDATE tables SET relations = %L WHERE tables.id = %L;', arg_payload, arg_table_id);
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;
    """)
  end

  def down do
    execute("DROP FUNCTION update_relations_for_table();")
  end
end
