defmodule Dynamic.Repo.Migrations.CascadeDeleteForTableFunction do
  use Ecto.Migration

  def change do
    execute("""
    CREATE OR REPLACE FUNCTION cascade_delete_for_table() RETURNS TRIGGER AS
    $$
    DECLARE
        arg_table  text;
        arg_column text;
        old_id     uuid;
    BEGIN
        arg_table := TG_ARGV[0];
        arg_column := TG_ARGV[1];
        old_id := OLD.id;
        EXECUTE format('DELETE FROM %s WHERE %s.%s = %L;', arg_table, arg_table, arg_column, old_id);
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;
    """)
  end

  def down do
    execute("DROP FUNCTION cascade_delete_for_table();")
  end
end
