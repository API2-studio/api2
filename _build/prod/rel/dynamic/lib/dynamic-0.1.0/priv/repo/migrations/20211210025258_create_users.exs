defmodule Dynamic.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false, options: "INHERITS (base)") do
      add(:id, :uuid, null: false, autogenerate: true)
      add(:name, :string, null: false)
      add(:email, :string, null: false, unique: true)
      add(:password_hash, :string)
      add(:last_active, :timestamptz, null: false, default: fragment("now()"))
      add(:avatar, :string )
      timestamps([type: :timestamptz, extended: true, abbrev: true])
    end

    create(unique_index(:users, [:id]))
    create(unique_index(:users, [:email]))

  end

  def down do
    drop table(:users)
  end

end
