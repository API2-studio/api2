defmodule Dynamic.Repo.Migrations.CreateFkForUsersGroupsTable do
  use Ecto.Migration

  def change do
    # execute("""
    # CREATE TRIGGER pseudofk_user_id BEFORE INSERT OR UPDATE ON user_groups FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(users, user_id);
    # """)
    # execute("""
    # CREATE TRIGGER pseudofk_group_id BEFORE INSERT OR UPDATE ON user_groups FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(groups, group_id);
    # """)
    # execute("""
    # CREATE TRIGGER cascade_user_id_user_groups BEFORE DELETE ON users FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(user_groups, user_id);
    # """)
    # execute("""
    # CREATE TRIGGER cascade_group_id_user_groups BEFORE DELETE ON groups FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(user_groups, group_id);
    # """)
  end

  def down do
    # execute("DROP TRIGGER pseudofk_user_id ON user_groups;")
    # execute("DROP TRIGGER pseudofk_group_id ON user_groups;")
    # execute("DROP TRIGGER cascade_user_id_user_groups ON users;")
    # execute("DROP TRIGGER cascade_group_id_user_groups ON groups;")
  end
end
