defmodule Dynamic.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true # primary key
      add :table_name, :string # table name (e.g. "users")
      add :record_id, :uuid, null: false # record id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :table_id, :uuid, null: false # table id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :created_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :updated_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :old_value, :map # old value of the record (e.g. {"name" => "John Doe"})
      add :new_value, :map  # new value of the record (e.g. {"name" => "John Doe"})
      add :data_type, :string # data type of the record (e.g. "integer")

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    create unique_index(:records, [:id])
  end

  def down do
    drop table(:records)
  end
end
