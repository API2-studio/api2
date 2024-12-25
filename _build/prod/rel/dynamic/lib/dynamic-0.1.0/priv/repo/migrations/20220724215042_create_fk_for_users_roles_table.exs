defmodule Dynamic.Repo.Migrations.CreateFkForUsersRolesTable do
  use Ecto.Migration

  def change do
    # execute("""
    # CREATE TRIGGER pseudofk_user_id BEFORE INSERT OR UPDATE ON user_roles FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(users, user_id);
    # """)
    # execute("""
    # CREATE TRIGGER pseudofk_role_id BEFORE INSERT OR UPDATE ON user_roles FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(roles, role_id);
    # """)
    # execute("""
    # CREATE TRIGGER cascade_user_id_user_roles BEFORE DELETE ON users FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(user_roles, user_id);
    # """)
    # execute("""
    # CREATE TRIGGER cascade_role_id_user_roles BEFORE DELETE ON users FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(user_roles, role_id);
    # """)
  end

  def down do
    # execute("DROP TRIGGER pseudofk_user_id ON user_roles;")
    # execute("DROP TRIGGER pseudofk_role_id ON user_roles;")
    # execute("DROP TRIGGER cascade_user_id_user_roles ON users;")
    # execute("DROP TRIGGER cascade_role_id_user_roles ON users;")
  end
end
