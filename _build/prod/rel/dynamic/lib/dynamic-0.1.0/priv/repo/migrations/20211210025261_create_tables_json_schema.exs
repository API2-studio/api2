defmodule Dynamic.Repo.Migrations.TablesJsonSchema do
  use Ecto.Migration
  alias Dynamic.BaseStructures
  alias Dynamic.Utils
  alias Dynamic.Docs.JsonSchemaCompiler


  def change do

    roles_table = BaseStructures.get_table_from_name!("roles")
    roles_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(roles_table))

    execute("""
    UPDATE tables SET json_schema = '#{roles_json_schema}' WHERE name = 'roles';
    """)

    groups_table = BaseStructures.get_table_from_name!("groups")
    groups_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(groups_table))

    execute("""
    UPDATE tables SET json_schema = '#{groups_json_schema}' WHERE name = 'groups';
    """)

    users_table = BaseStructures.get_table_from_name!("users")
    users_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(users_table))

    execute("""
    UPDATE tables SET json_schema = '#{users_json_schema}' WHERE name = 'users';
    """)

    user_roles_table = BaseStructures.get_table_from_name!("user_roles")
    user_roles_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(user_roles_table))

    execute("""
    UPDATE tables SET json_schema = '#{user_roles_json_schema}' WHERE name = 'user_roles';
    """)

    user_groups_table = BaseStructures.get_table_from_name!("user_groups")
    user_groups_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(user_groups_table))

    execute("""
    UPDATE tables SET json_schema = '#{user_groups_json_schema}' WHERE name = 'user_groups';
    """)

    group_roles_table = BaseStructures.get_table_from_name!("group_roles")
    group_roles_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(group_roles_table))

    execute("""
    UPDATE tables SET json_schema = '#{group_roles_json_schema}' WHERE name = 'group_roles';
    """)

    documents_table = BaseStructures.get_table_from_name!("documents")
    documents_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(documents_table))

    execute("""
    UPDATE tables SET json_schema = '#{documents_json_schema}' WHERE name = 'documents';
    """)

    tables_table = BaseStructures.get_table_from_name!("tables")
    tables_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(tables_table))

    execute("""
    UPDATE tables SET json_schema = '#{tables_json_schema}' WHERE name = 'tables';
    """)

    # execute for views
    records_table = BaseStructures.get_table_from_name!("records")
    records_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(records_table))

    execute("""
    UPDATE tables SET json_schema = '#{records_json_schema}' WHERE name = 'records';
    """)

    # execute for views
    views_table = BaseStructures.get_table_from_name!("views")
    views_json_schema = Jason.encode!(JsonSchemaCompiler.generate_schema(views_table))

    execute("""
    UPDATE tables SET json_schema = '#{views_json_schema}' WHERE name = 'views';
    """)
  end

  def down do
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'roles';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'groups';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'users';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'user_roles';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'user_groups';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'group_roles';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'documents';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'tables';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'records';")
    execute("UPDATE tables SET json_schema = NULL WHERE name = 'views';")
  end
end
