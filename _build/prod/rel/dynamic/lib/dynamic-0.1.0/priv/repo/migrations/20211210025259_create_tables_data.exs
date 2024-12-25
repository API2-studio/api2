defmodule Dynamic.Repo.Migrations.TablesData do
  use Ecto.Migration
  # alias Dynamic.BaseContent
  # alias Dynamic.BaseStructures
  # alias Dynamic.Utils

  @system_id Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()

  def change do

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'roles', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'roles' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, NULL, false);
    """)
    # BaseStructures.create_table(%{
    #   name: "roles",
    #   parent: "base",
    #   schema: Utils.get_table_schema("roles"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'groups', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'groups' AND t.table_schema = 'public'), '#{@system_id}', '#{@system_id}', NULL, NULL, false);
    """)
    # BaseStructures.create_table(%{
    #   name: "groups",
    #   parent: "base",
    #   schema: Utils.get_table_schema("groups"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'users', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'users' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, false);
    """)
    # BaseStructures.create_table(%{
    #   name: "users",
    #   parent: "base",
    #   schema: Utils.get_table_schema("users"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'user_roles', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'user_roles' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, false);
    """)
    # BaseStructures.create_table(%{
    #   name: "user_roles",
    #   parent: "base",
    #   schema: Utils.get_table_schema("user_roles"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })


    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'group_roles', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'group_roles' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, false);
    """)
    # BaseStructures.create_table(%{
    #   name: "group_roles",
    #   parent: "base",
    #   schema: Utils.get_table_schema("group_roles"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'user_groups', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'user_groups' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, false);
    """)
    # BaseStructures.create_table(%{
    #   name: "user_groups",
    #   parent: "base",
    #   schema: Utils.get_table_schema("user_groups"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'documents', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'documents' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, true);
    """)
    # BaseStructures.create_table(%{
    #   name: "documents",
    #   parent: "base",
    #   schema: Utils.get_table_schema("documents"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'tables', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'tables' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, true);
    """)
    # BaseStructures.create_table(%{
    #   name: "tables",
    #   parent: "base",
    #   schema: Utils.get_table_schema("tables"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'records', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'records' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, true);
    """)
    # BaseStructures.create_table(%{
    #   name: "records",
    #   parent: "base",
    #   schema: Utils.get_table_schema("records"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })

    execute("""
    INSERT INTO tables (id, inserted_at, updated_at, name, parent, schema, created_by, updated_by, relations, permissions, searchable)
      VALUES (gen_random_uuid()::uuid, timezone('utc', now()), timezone('utc', now()), 'views', 'base', (SELECT json_agg(json_build_object('name', t.column_name, 'type', t.udt_name)) FROM information_schema.columns AS t WHERE table_name = 'views' AND t.table_schema = 'public'), '#{ @system_id}', '#{ @system_id}', NULL, NULL, true);
    """)
    # BaseStructures.create_table(%{
    #   name: "views",
    #   parent: "base",
    #   schema: Utils.get_table_schema("views"),
    #   created_by: @system_id,
    #   updated_by: @system_id
    # })
  end

  def down do
    execute("DELETE FROM tables WHERE name = 'roles';")
    execute("DELETE FROM tables WHERE name = 'groups';")
    execute("DELETE FROM tables WHERE name = 'users';")
    execute("DELETE FROM tables WHERE name = 'user_roles';")
    execute("DELETE FROM tables WHERE name = 'group_roles';")
    execute("DELETE FROM tables WHERE name = 'user_groups';")
    execute("DELETE FROM tables WHERE name = 'documents';")
    execute("DELETE FROM tables WHERE name = 'tables';")
    execute("DELETE FROM tables WHERE name = 'records';")
    execute("DELETE FROM tables WHERE name = 'views';")
  end

end
