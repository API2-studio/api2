defmodule Dynamic.Repo.Migrations.CreateFkForTasksTable do
  use Ecto.Migration

  def change do
  #   execute("""
  #     CREATE TRIGGER pseudofk_worflow_id_tasks BEFORE INSERT OR UPDATE ON tasks FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(workflows, workflow_id);
  #   """)


  #   execute("""
  #     CREATE TRIGGER cascade_workflow_id_tasks BEFORE DELETE ON workflows FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(tasks, workflow_id);
  #   """)


  #   execute("""
  #     CREATE TRIGGER pseudofk_worflow_id_workflow_states BEFORE INSERT OR UPDATE ON workflow_states FOR EACH ROW EXECUTE PROCEDURE pseudo_fk_for_table(workflows, workflow_id);
  #   """)


  #   execute("""
  #     CREATE TRIGGER cascade_workflow_id_workflow_states BEFORE DELETE ON workflows FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(workflow_states, workflow_id);
  #   """)


  #   execute("""
  #     CREATE TRIGGER cascade_task_id_workflow_states BEFORE DELETE ON workflows FOR EACH ROW EXECUTE PROCEDURE cascade_delete_for_table(workflow_states, task_id);
  #   """)
  # end

  # def down do
  #   execute("DROP TRIGGER pseudofk_worflow_id_tasks ON tasks;")
  #   execute("DROP TRIGGER cascade_workflow_id_tasks ON workflows;")
  #   execute("DROP TRIGGER pseudofk_worflow_id_workflow_states ON workflow_states;")
  #   execute("DROP TRIGGER cascade_workflow_id_workflow_states ON workflows;")
  #   execute("DROP TRIGGER pseudofk_task_id_workflow_states ON workflow_states;")
  #   execute("DROP TRIGGER cascade_task_id_workflow_states ON workflows;")
  end
end
