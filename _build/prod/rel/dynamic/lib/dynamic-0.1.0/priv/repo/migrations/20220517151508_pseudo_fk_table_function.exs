defmodule Dynamic.Repo.Migrations.PseudoFkTableFunction do
  use Ecto.Migration

  def up do
    execute("""
    CREATE OR REPLACE FUNCTION pseudo_fk_for_table()
        RETURNS TRIGGER
    AS
    $$
    DECLARE
        arg_table  text;
        arg_column text;
        payload    int := 0;
    BEGIN
        arg_table := TG_ARGV[0];
        arg_column := TG_ARGV[1];
        EXECUTE format('SELECT 1 FROM %s WHERE id = $1.%s;', arg_table, arg_column) INTO payload using NEW;

        IF payload = 1 THEN return NEW;  ELSE RAISE EXCEPTION 'No % with that id', arg_table;  END IF;
    END;

    $$
        LANGUAGE plpgsql;
    """)
  end

  def down do
    execute("DROP FUNCTION pseudo_fk_for_table();")
  end
end
