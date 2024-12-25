defmodule Dynamic.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false, options: "INHERITS (base)") do
      add :id, :uuid, null: false, autogenerate: true # primary key
      add :record_id, :uuid, null: false # record id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :table_name, :string # table name (e.g. "users")
      add :table_id, :uuid, null: false # table id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :created_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :updated_by, :uuid, null: false # user id (e.g. "12345678-1234-1234-1234-1234567890ab")
      add :value, :map  # new value of the record (e.g. {"name" => "John Doe"})
      add :data_type, :string # data type of the record (e.g. "integer")
      add :acl, :map # access control list for the document

      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end
    create unique_index(:documents, [:id])
    create unique_index(:documents, [:record_id])
    # create unique_index(:documents, [:table_name, :table_id])

    create index(:documents, [:created_by])
    create index(:documents, [:updated_by])

  end

  def down do
    drop table(:documents)
  end
end
