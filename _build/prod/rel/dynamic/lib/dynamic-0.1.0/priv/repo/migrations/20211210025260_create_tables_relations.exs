defmodule Dynamic.Repo.Migrations.TablesRelations do
  use Ecto.Migration
  alias Dynamic.BaseContent
  alias Dynamic.BaseStructures
  alias Dynamic.Utils

  def change do
    user_roles_relations = [
      %{
        "relation_type" => "many-to-many",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "table" => %{
          "column" => "user_id",
          "id" =>  Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        }
      },
      %{
        "relation_type" => "many-to-many",
        "references_table" => %{
          "column" => "id",
          "id" => Utils.get_table_id_from_name("roles"),
          "name" => "roles"
        },
        "table" => %{
          "column" => "role_id",
          "id" =>  Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        }
      }
    ]

    user_groups_relations = [
      %{
        "relation_type" => "many-to-many",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        }
      },
      %{
        "relation_type" => "many-to-many",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("groups")),
          "name" => "groups"
        },
        "table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        }
      }
    ]

    group_roles_relations = [
      %{
        "relation_type" => "many-to-many",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("groups")),
          "name" => "groups"
        },
        "table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        }
      },
      %{
        "relation_type" => "many-to-many",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "roles"
        },
        "table" => %{
          "column" => "role_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        }
      }
    ]

    execute("""
    UPDATE tables SET relations = '#{Jason.encode!(user_roles_relations)}' WHERE name = 'user_roles';
    """)

    execute("""
    UPDATE tables SET relations = '#{Jason.encode!(user_groups_relations)}' WHERE name = 'user_groups';
    """)

    execute("""
    UPDATE tables SET relations = '#{Jason.encode!(group_roles_relations)}' WHERE name = 'group_roles';
    """)

  end

  def down do
    execute("""
    UPDATE tables SET relations = NULL WHERE name = 'user_roles';
    """)

    execute("""
    UPDATE tables SET relations = NULL WHERE name = 'user_groups';
    """)

    execute("""
    UPDATE tables SET relations = NULL WHERE name = 'group_roles';
    """)
  end
end
