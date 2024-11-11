# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dynamic.Repo.insert!(%Dynamic.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# You can also use the Ecto.Query API to fetch data:
#
alias Dynamic.Elasticsearch.Document
alias Dynamic.Repo
alias Dynamic.BaseContent
alias Dynamic.Docs.DocsGenerator
alias Dynamic.AvatarUploader.File
# alias Dynamic.Logger
alias Dynamic.Elasticsearch.Document




# start the repo to be able to use it
Repo.start_link()

import Logger
role_fields = %{
  name: "admin",
  registerable: false,
  permissions: %{
    #  Base Permissions
    base: [:create, :read, :update, :delete],
    schema: [:create, :read, :update, :delete],
    auth: [:create, :read, :update, :delete],
    structure: [:create, :read, :update, :delete],
    data: [:create, :read, :update, :delete],
    view: [:create, :read, :update, :delete],
    tables: [:create, :read, :update, :delete],
    views: [:create, :read, :update, :delete],
    records: [:create, :read, :update, :delete],
    documents: [:create, :read, :update, :delete],
    acls: [:create, :read, :update, :delete],
    permissions: [:create, :read, :update, :delete],
    settings: [:create, :read, :update, :delete],
    logs: [:create, :read, :update, :delete],
    notifications: [:create, :read, :update, :delete],
    reports: [:create, :read, :update, :delete],
    dashboards: [:create, :read, :update, :delete],
    queries: [:create, :read, :update, :delete],
    integrations: [:create, :read, :update, :delete],
    connections: [:create, :read, :update, :delete],
    data_sources: [:create, :read, :update, :delete],
    channels: [:create, :read, :update, :delete],
    external_services: [:create, :read, :update, :delete],
    gcp: [:create, :read, :update, :delete],
    aws: [:create, :read, :update, :delete],
    azure: [:create, :read, :update, :delete],
    audit: [:create, :read, :update, :delete],
    #  Table Permissions
    files: [:create, :read, :update, :delete],
    roles: [:create, :read, :update, :delete],
    users: [:create, :read, :update, :delete],
    groups: [:create, :read, :update, :delete],
    group_roles: [:create, :read, :update, :delete],
    user_roles: [:create, :read, :update, :delete],
    user_groups: [:create, :read, :update, :delete],
    # Refactor this so only create these if licence is valid
    # workflows: [:create, :read, :update, :delete],
    # steps: [:create, :read, :update, :delete],
    # actions: [:create, :read, :update, :delete],
    # conditions: [:create, :read, :update, :delete],
    request_logs: [:create, :read, :update, :delete],
    logs: [:create, :read, :update, :delete],
    configs: [:create, :read, :update, :delete],
    search: [:create, :read, :update, :delete],
    files: [:create, :read, :update, :delete],
    endpoints: [:create, :read, :update, :delete],
  }
}

#  If role already exists, don't create it
case BaseContent.get_role_by_name!("admin") do
  {:ok, _} -> Logger.info("Role already exists")
  {:error, _} ->
    Logger.info("Creating role")

    with {:ok, role} <- BaseContent.create_role(role_fields, Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()),
    {:ok, user} <- BaseContent.create_user(%{
        "name" => System.get_env("ADMIN_NAME"),
        "email" => System.get_env("ADMIN_EMAIL"),
        "password" => System.get_env("ADMIN_PASSWORD"),
        "password_confirmation" => System.get_env("ADMIN_PASSWORD"),
        "user_roles" => [%{role_id: "#{role.id}"}],
      }),
    {:ok, _user } <- BaseContent.get_user(user.id) do
        Logger.info("Admin user created")
    else
      {:error, _reason} -> Logger.info("Admin user not created")
      :error -> Logger.info("Error creating admin user")
    end
end

#  Create default configs in the configs table
configs = Application.get_all_env(:dynamic)

# Convert list of tuples to map
configs = Enum.into(configs, %{})


# Loop through the map and convert all nested values with convert_to_map function in utils with reduce function
configs = Enum.reduce(configs, %{}, fn {key, value}, acc ->
  key  = Atom.to_string(key)
  new_value = Dynamic.Utils.convert_to_map(value)
  Map.put(acc, key, new_value)
end)

{:ok, user} = BaseContent.get_user_by_email_and_password(System.get_env("ADMIN_EMAIL"), System.get_env("ADMIN_PASSWORD"))

# Insert the configs into the database
Enum.each(configs, fn {key, value} ->
  case BaseContent.get_config_by_key(key) do
    {:ok, _} ->IO.puts("Config already exists")
    {:error, _} ->
      IO.puts("Creating config")
      BaseContent.create_config(user, %{
        "application" => "dynamic",
        "key" => key,
        "value" => value
      })
  end
end)


  # Stop the repo
Repo.stop()
