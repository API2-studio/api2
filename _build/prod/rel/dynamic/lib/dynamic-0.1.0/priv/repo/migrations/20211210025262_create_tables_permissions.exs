defmodule Dynamic.Repo.Migrations.TablesPermissions do
  use Ecto.Migration
  alias Dynamic.BaseContent
  alias Dynamic.BaseStructures
  alias Dynamic.Utils

  def change do
    roles_perms = %{
      roles: [:create, :read, :update, :delete]
    }
    groups_perms = %{
      groups: [:create, :read, :update, :delete]
    }
    users_perms = %{
      users: [:create, :read, :update, :delete]
    }
    user_roles_perms = %{
      user_roles: [:create, :read, :update, :delete]
    }
    user_groups_perms = %{
      user_groups: [:create, :read, :update, :delete]
    }
    groups_roles_perms = %{
      group_roles: [:create, :read, :update, :delete]
    }
    documents_perms = %{
      documents: [:create, :read, :update, :delete]
    }
    tables_perms = %{
      tables: [:create, :read, :update, :delete]
    }
    records_perms = %{
      records: [:create, :read, :update, :delete]
    }
    views_perms = %{
      views: [:create, :read, :update, :delete]
    }
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(roles_perms)}' WHERE name = 'roles';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(groups_perms)}' WHERE name = 'groups';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(users_perms)}' WHERE name = 'users';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(user_roles_perms)}' WHERE name = 'user_roles';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(user_groups_perms)}' WHERE name = 'user_groups';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(groups_roles_perms)}' WHERE name = 'group_roles';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(documents_perms)}' WHERE name = 'documents';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(tables_perms)}' WHERE name = 'tables';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(records_perms)}' WHERE name = 'records';
    """)
    execute("""
    UPDATE tables SET permissions = '#{Jason.encode!(views_perms)}' WHERE name = 'views';
    """)

  end

  def down do
    execute("UPDATE tables SET permissions = NULL WHERE name = 'roles';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'groups';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'users';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'user_roles';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'user_groups';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'group_roles';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'documents';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'tables';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'records';")
    execute("UPDATE tables SET permissions = NULL WHERE name = 'views';")
  end
end
