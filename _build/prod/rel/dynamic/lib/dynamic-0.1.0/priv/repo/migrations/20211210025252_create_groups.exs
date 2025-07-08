defmodule Dynamic.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, options: "INHERITS (base)") do
      # add(:id, :binary_id, primary_key: true)
      add :name, :string
      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    # create unique_index(:groups, [:id])
    create unique_index(:groups, [:name])

    create index(:groups, [:inserted_at])
    create index(:groups, [:updated_at])
    create index(:groups, [:deleted_at])
    create index(:groups, [:archived_at])


  end

  def down do
    drop table(:groups)
  end
end
