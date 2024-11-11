defmodule Dynamic.Repo.Migrations.TriggerSetTimestampFunction do
  use Ecto.Migration

  def change do
    execute("""
    CREATE OR REPLACE FUNCTION trigger_set_timestamp()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = timezone('utc', now());
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """)
  end

  def down do
    execute("DROP FUNCTION trigger_set_timestamp();")
  end
end
