defmodule Dynamic.Repo.Migrations.CreateViews do
  use Ecto.Migration

  def change do
    create table(:views, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true # primary key
      add :name, :string # table name (e.g. "users")
      add :schema,:map
      add :created_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :updated_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :data_type, :string # data type of the record (e.g. "integer")
      add :permissions, :map # permissions for the table

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    create unique_index(:views, [:id])
    create unique_index(:views, [:name])
  end

  def down do
    drop table(:views)
  end
end
