defmodule Dynamic.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false, options: "INHERITS (base)") do
      add(:id, :binary_id, primary_key: true)
      add :name, :string
      add :permissions, :map
      add :registerable, :boolean
      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create unique_index(:roles, [:id, :registerable, :name])

    create unique_index(:roles, [:name])
  end

  def down do
    drop table(:roles)
  end
end
