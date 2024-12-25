defmodule Dynamic.Repo.Migrations.CreateFkForGroupsRolesTable do
  use Ecto.Migration

  def change do
    # execute("""
    # CREATE TRIGGER pseudofk_group_id BEFORE INSERT OR UPDATE ON group_roles FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(groups, group_id);
    # """)
    # execute("""
    # CREATE TRIGGER pseudofk_role_id BEFORE INSERT OR UPDATE ON group_roles FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(roles, role_id);
    # """)
    # execute("""
    # CREATE TRIGGER cascade_group_id_group_roles BEFORE DELETE ON groups FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(group_roles, group_id);
    # """)
    # execute("""
    # CREATE TRIGGER cascade_role_id_group_roles BEFORE DELETE ON groups FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(group_roles, role_id);
    # """)
  end

  def down do
    # execute("DROP TRIGGER pseudofk_group_id ON group_roles;")
    # execute("DROP TRIGGER pseudofk_role_id ON group_roles;")
    # execute("DROP TRIGGER cascade_group_id_group_roles ON groups;")
    # execute("DROP TRIGGER cascade_role_id_group_roles ON groups;")
  end
end
