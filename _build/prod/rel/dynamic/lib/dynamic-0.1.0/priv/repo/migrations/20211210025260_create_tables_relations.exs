defmodule Dynamic.Repo.Migrations.TablesRelations do
  use Ecto.Migration
  alias Dynamic.BaseContent
  alias Dynamic.BaseStructures
  alias Dynamic.Utils

  def change do
    user_relations = [
      %{
        "relation_type" => "many-to-many",
        "relation_name" => "roles",
        "through_table" => %{
          "column" => "role_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        },
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "roles"
        },
        "table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        }
      },
      %{
        "relation_type" => "many-to-many",
        "relation_name" => "groups",
        "through_table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        },
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("groups")),
          "name" => "groups"
        },
        "table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        }
      },
      %{
        "relation_type" => "one-to-many",
        "relation_name" => "user_roles",
        "references_table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "users"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-many",
        "relation_name" => "user_groups",
        "references_table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("groups")),
          "name" => "users"
        },
        "through_table" => nil
      }
    ]

    group_relations = [
      %{
        "relation_type" => "many-to-many",
        "relation_name" => "roles",
        "through_table" => %{
          "column" => "role_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        },
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "roles"
        },
        "table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        }
      },
      %{
        "relation_type" => "many-to-many",
        "relation_name" => "users",
        "through_table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        },
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        }
      },
      %{
        "relation_type" => "one-to-many",
        "relation_name" => "group_roles",
        "references_table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "groups"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "one-to-many",
        "relation_name" => "user_groups",
        "references_table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        },
        "table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "through_table" => nil
      }
    ]

    role_relations = [
      %{
        "relation_type" => "many-to-many",
        "relation_name" => "users",
        "through_table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        },
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        }
      }
    ]

    user_roles_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "user",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "role",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "roles"
        },
        "table" => %{
          "column" => "role_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_roles")),
          "name" => "user_roles"
        },
        "through_table" => nil
      }
    ]

    user_groups_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "user",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("users")),
          "name" => "users"
        },
        "table" => %{
          "column" => "user_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "group",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("groups")),
          "name" => "groups"
        },
        "table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("user_groups")),
          "name" => "user_groups"
        },
        "through_table" => nil
      }
    ]

    group_roles_relations = [
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "group",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("groups")),
          "name" => "groups"
        },
        "table" => %{
          "column" => "group_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        },
        "through_table" => nil
      },
      %{
        "relation_type" => "many-to-one",
        "relation_name" => "role",
        "references_table" => %{
          "column" => "id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("roles")),
          "name" => "roles"
        },
        "table" => %{
          "column" => "role_id",
          "id" => Ecto.UUID.cast!(Utils.get_table_id_from_name("group_roles")),
          "name" => "group_roles"
        },
        "through_table" => nil
      }
    ]

    execute("""
    UPDATE tables SET relations = '#{Jason.encode!(user_relations)}' WHERE name = 'users';
    """)

    execute("""
    UPDATE tables SET relations = '#{Jason.encode!(group_relations)}' WHERE name = 'groups';
    """)

    execute("""
    UPDATE tables SET relations = '#{Jason.encode!(role_relations)}' WHERE name = 'roles';
    """)

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

    execute("""
    UPDATE tables SET relations = NULL WHERE name = 'users';
    """)

    execute("""
    UPDATE tables SET relations = NULL WHERE name = 'groups';
    """)

    execute("""
    UPDATE tables SET relations = NULL WHERE name = 'roles';
    """)
  end
end
