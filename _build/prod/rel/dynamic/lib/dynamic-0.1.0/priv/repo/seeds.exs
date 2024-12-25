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
alias Dynamic.Repo
alias Dynamic.BaseContent
alias Dynamic.BaseStructures
alias Dynamic.Docs.DocsGenerator
alias Dynamic.AvatarUploader.File
alias Dynamic.Elasticsearch.Index
alias Dynamic.Endpoints.EndpointHandler
alias Dynamic.Utils
alias Dynamic.JWT

# start the repo to be able to use it
# Repo.start_link()

import Logger

role_fields = %{
  name: "admin",
  registerable: false,
  permissions: JWT.available_permissions()
}

#  If role already exists, don't create it
case BaseContent.get_role_by_name!("admin") do
  {:ok, role} ->
    Logger.info("Role already exists")
    # Check if the admin user exists
    case BaseContent.get_user_by_email_and_password(
           System.get_env("ADMIN_EMAIL"),
           System.get_env("ADMIN_PASSWORD")
         ) do
      {:ok, _} ->
        Logger.info("Admin user already exists")

      {:error, _} ->
        Logger.info("Admin user does not exist")
        # Create the admin user
        with {:ok, user} <-
               BaseContent.create_user(%{
                 "name" => System.get_env("ADMIN_NAME"),
                 "email" => System.get_env("ADMIN_EMAIL"),
                 "password" => System.get_env("ADMIN_PASSWORD"),
                 "password_confirmation" => System.get_env("ADMIN_PASSWORD"),
                 "user_roles" => [%{role_id: "#{role.id}"}]
               }) do
          Logger.info("Admin user created")

          #  Create default configs in the configs table
          configs = Application.get_all_env(:dynamic)

          # Convert list of tuples to map
          configs = Enum.into(configs, %{})

          # Loop through the map and convert all nested values with convert_to_map function in utils with reduce function
          configs =
            Enum.reduce(configs, %{}, fn {key, value}, acc ->
              key = Atom.to_string(key)
              new_value = Utils.convert_to_map(value)
              Map.put(acc, key, new_value)
            end)

          # Insert the configs into the database
          Enum.each(configs, fn {key, value} ->
            case BaseContent.get_config_by_key(key) do
              {:ok, _} ->
                IO.puts("Config already exists")

              {:error, _} ->
                IO.puts("Creating config")

                BaseContent.create_config(user, %{
                  "application" => "dynamic",
                  "key" => key,
                  "value" => value
                })
            end
          end)

          # Create the endpoints

          # Get the base tables
          tables = BaseStructures.list_tables()

          payload =
            tables
            |> Enum.map(fn table ->
              # Index endpoints for tables
              %{
                "url" => "/api/v1/base/#{table.name}",
                "method" => "GET",
                "json_schema" => %{
                  "type" => "object",
                  "properties" =>
                    Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                      case name do
                        "acl" -> acc
                        "password" -> acc
                        "password_confirmation" -> acc
                        "password_hash" -> acc
                        _ -> Map.put(acc, name, %{"type" => "string"})
                      end
                    end)
                    |> Map.put("limit", %{"type" => "string"})
                    |> Map.put("offset", %{"type" => "string"})
                    |> Map.put("order_column", %{"type" => "string"})
                    |> Map.put("order_direction", %{"type" => "string"})
                    |> Map.put("page", %{"type" => "string"})
                    |> Map.put("page_size", %{"type" => "string"}),
                  "required" => [
                    "limit",
                    "offset",
                    "order_column",
                    "order_direction",
                    "page",
                    "page_size"
                  ],
                  "additionalProperties" => false
                },
                "source_table_id" => table.id,
                "query" => %{
                  "filters" =>
                    table.schema
                    |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                      # Create a new map with the column name as the key and the column name in {} as the value
                      case name do
                        "acl" -> acc
                        "password" -> acc
                        "password_confirmation" -> acc
                        "password_hash" -> acc
                        "archived_at" -> Map.put(acc, name, %{"lte" => "{#{name}}"})
                        "deleted_at" -> Map.put(acc, name, %{"lte" => "{#{name}}"})
                        "inserted_at" -> Map.put(acc, name, %{"gte" => "{#{name}}"})
                        "updated_at" -> Map.put(acc, name, %{"gte" => "{#{name}}"})
                        _ -> Map.put(acc, name, "{#{name}}")
                      end
                    end),
                  "limit" => "{limit}",
                  "offset" => "{offset}",
                  "preloads" => [],
                  "schema" => table.name,
                  "sort" => [
                    %{
                      "field" => "{order_column}",
                      "order" => "{order_direction}"
                    }
                  ],
                  "page" => "{page}",
                  "page_size" => "{page_size}"
                },
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_confirmation"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_hash"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Get all #{table.name}",
                "query_params_schema" => %{
                  "limit" => "{limit}",
                  "offset" => "{offset}",
                  "order_column" => "{order_column}",
                  "order_direction" => "{order_direction}",
                  "page" => "{page}",
                  "page_size" => "{page_size}"
                },
                "url_params_schema" => %{},
                "body_params_schema" => nil,
                "permissions" => %{
                  "#{table.name}_index_endpoint" => [
                    "read"
                  ]
                }
              }
            end)
            |> Enum.map(fn endpoint ->
              EndpointHandler.create_endpoint(user, endpoint)
            end)

          payload2 =
            tables
            |> Enum.map(fn table ->
              # Show endpoints for tables
              %{
                "url" => "/api/v1/base/#{table.name}/{id}",
                "method" => "GET",
                "json_schema" => %{
                  "type" => "object",
                  "properties" => %{
                    "id" => %{
                      "type" => "string"
                    }
                  },
                  "required" => [],
                  "additionalProperties" => false
                },
                "source_table_id" => table.id,
                "query" => %{
                  "filters" => %{
                    "id" => "{id}"
                  },
                  "preloads" => [],
                  "schema" => table.name,
                  "limit" => 1,
                  "offset" => 0,
                  "sort" => [
                    %{
                      "field" => "id",
                      "order" => "asc"
                    }
                  ]
                },
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_confirmation"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_hash"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Get a #{table.name} by id",
                "query_params_schema" => %{},
                "url_params_schema" => %{
                  "id" => "{id}"
                },
                "body_params_schema" => nil,
                "permissions" => %{
                  "#{table.name}_read_endpoint" => [
                    "read"
                  ]
                }
              }
            end)
            |> Enum.map(fn endpoint ->
              EndpointHandler.create_endpoint(user, endpoint)
            end)

          payload3 =
            tables
            |> Enum.map(fn table ->
              # Create endpoints for tables
              case table.name do
                "users" ->
                  %{
                    "url" => "/api/v1/base/#{table.name}",
                    "method" => "POST",
                    "json_schema" => %{
                      "type" => "object",
                      "properties" =>
                        table.schema
                        |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                          Map.put(acc, name, %{
                            "type" => "string"
                          })
                          |> Map.reject(fn {key, _} ->
                            key == "password_hash"
                          end)
                          |> Map.reject(fn {key, _} ->
                            key == "acl"
                          end)
                          |> Map.put("password", %{
                            "type" => "string"
                          })
                          |> Map.put("password_confirmation", %{
                            "type" => "string"
                          })
                          |> Map.put("role_id", %{
                            "type" => "string"
                          })
                        end),
                      "required" => [
                        "email",
                        "password",
                        "password_confirmation",
                        "role_id"
                      ],
                      "additionalProperties" => false
                    },
                    "source_table_id" => table.id,
                    "query" => nil,
                    "response_template" => %{
                      "fields" =>
                        table.schema
                        |> Enum.reduce([], fn %{"name" => name}, acc ->
                          acc ++ [name]
                        end)
                        |> Enum.reject(fn field ->
                          field == "acl"
                        end)
                        |> Enum.reject(fn field ->
                          field == "password"
                        end)
                        |> Enum.reject(fn field ->
                          field == "password_confirmation"
                        end)
                        |> Enum.reject(fn field ->
                          field == "password_hash"
                        end)
                    },
                    "auth_required" => true,
                    "rate_limit" => 100,
                    #  Change this to false if you want to disable the endpoint TODO: disable this by default
                    "enabled" => true,
                    "description" => "Create a new #{table.name}",
                    "query_params_schema" => %{},
                    "url_params_schema" => %{},
                    "body_params_schema" =>
                      Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                        # merge all the columns into a map with the column name as the key and the column name in {} as the value
                        Map.put(acc, name, "{#{name}}")
                      end)
                      |> Map.put("password", "{password}")
                      |> Map.put("password_confirmation", "{password_confirmation}")
                      |> Map.put("user_roles", [
                        %{
                          "role_id" => "{role_id}",
                        }
                      ]),
                    "permissions" => %{
                      "#{table.name}_create_endpoint" => [
                        "create"
                      ]
                    }
                  }

                _ ->
                  %{
                    "url" => "/api/v1/base/#{table.name}",
                    "method" => "POST",
                    "json_schema" => %{
                      "type" => "object",
                      "properties" =>
                        table.schema
                        |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                          Map.put(acc, name, %{
                            "type" => "string"
                          })
                          |> Map.reject(fn {key, _} ->
                            key == "acl"
                          end)
                        end),
                      "required" => [],
                      "additionalProperties" => false
                    },
                    "source_table_id" => table.id,
                    "query" => nil,
                    "response_template" => %{
                      "fields" =>
                        table.schema
                        |> Enum.reduce([], fn %{"name" => name}, acc ->
                          acc ++ [name]
                        end)
                        |> Enum.reject(fn field ->
                          field == "acl"
                        end)
                    },
                    "auth_required" => true,
                    "rate_limit" => 100,
                    #  Change this to false if you want to disable the endpoint TODO: disable this by default
                    "enabled" => true,
                    "description" => "Create a new #{table.name}",
                    "query_params_schema" => %{},
                    "url_params_schema" => %{},
                    "body_params_schema" =>
                      Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                        # merge all the columns into a map with the column name as the key and the column name in {} as the value
                        Map.put(acc, name, "{#{name}}")
                      end),
                    "permissions" => %{
                      "#{table.name}_create_endpoint" => [
                        "create"
                      ]
                    }
                  }
              end
            end)
            |> Enum.map(fn endpoint ->
              EndpointHandler.create_endpoint(user, endpoint)
            end)

          payload4 =
            tables
            |> Enum.map(fn table ->
              case table.name do
                "users" ->
                  # Update endpoints for tables
                  %{
                    "url" => "/api/v1/base/#{table.name}/{id}",
                    "method" => "PUT",
                    "json_schema" => %{
                      "type" => "object",
                      "properties" =>
                        table.schema
                        |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                          Map.put(acc, name, %{
                            "type" => "string"
                          })
                          |> Map.reject(fn {key, _} ->
                            key == "password_hash"
                          end)
                          |> Map.reject(fn {key, _} ->
                            key == "acl"
                          end)
                          |> Map.put("password", %{
                            "type" => "string"
                          })
                          |> Map.put("password_confirmation", %{
                            "type" => "string"
                          })
                          |> Map.put("role_id", %{
                            "type" => "string"
                          })
                        end),
                      "required" => [
                        "email",
                        "password",
                        "password_confirmation",
                        "role_id"
                      ],
                      "additionalProperties" => false
                    },
                    "source_table_id" => table.id,
                    "query" => nil,
                    "response_template" => %{
                      "fields" =>
                        table.schema
                        |> Enum.reduce([], fn %{"name" => name}, acc ->
                          acc ++ [name]
                        end)
                        |> Enum.reject(fn field ->
                          field == "acl"
                        end)
                        |> Enum.reject(fn field ->
                          field == "password"
                        end)
                        |> Enum.reject(fn field ->
                          field == "password_confirmation"
                        end)
                        |> Enum.reject(fn field ->
                          field == "password_hash"
                        end)
                    },
                    "auth_required" => true,
                    "rate_limit" => 100,
                    #  Change this to false if you want to disable the endpoint TODO: disable this by default
                    "enabled" => true,
                    "description" => "Update a #{table.name} by id",
                    "query_params_schema" => %{},
                    "url_params_schema" => %{
                      "id" => "{id}"
                    },
                    "body_params_schema" =>
                      Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                        # merge all the columns into a map with the column name as the key and the column name in {} as the value
                        Map.put(acc, name, "{#{name}}")
                      end)
                      |> Map.put("password", "{password}")
                      |> Map.put("password_confirmation", "{password_confirmation}")
                      |> Map.put("user_roles", [
                        %{
                          "role_id" => "{role_id}"
                        }
                      ]),
                    "permissions" => %{
                      "#{table.name}_update_endpoint" => [
                        "update"
                      ]
                    }
                  }

                _ ->
                  # Update endpoints for tables
                  %{
                    "url" => "/api/v1/base/#{table.name}/{id}",
                    "method" => "PUT",
                    "json_schema" => %{
                      "type" => "object",
                      "properties" =>
                        table.schema
                        |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                          Map.put(acc, name, %{
                            "type" => "string"
                          })
                          |> Map.reject(fn {key, _} ->
                            key == "acl"
                          end)
                        end),
                      "required" => [],
                      "additionalProperties" => false
                    },
                    "source_table_id" => table.id,
                    "query" => nil,
                    "response_template" => %{
                      "fields" =>
                        table.schema
                        |> Enum.reduce([], fn %{"name" => name}, acc ->
                          acc ++ [name]
                        end)
                        |> Enum.reject(fn field ->
                          field == "acl"
                        end)
                    },
                    "auth_required" => true,
                    "rate_limit" => 100,
                    #  Change this to false if you want to disable the endpoint TODO: disable this by default
                    "enabled" => true,
                    "description" => "Update a #{table.name} by id",
                    "query_params_schema" => %{},
                    "url_params_schema" => %{
                      "id" => "{id}"
                    },
                    "body_params_schema" =>
                      Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                        # merge all the columns into a map with the column name as the key and the column name in {} as the value
                        Map.put(acc, name, "{#{name}}")
                      end),
                    "permissions" => %{
                      "#{table.name}_update_endpoint" => [
                        "update"
                      ]
                    }
                  }
              end
            end)
            |> Enum.map(fn endpoint ->
              EndpointHandler.create_endpoint(user, endpoint)
            end)

          payload5 =
            tables
            |> Enum.map(fn table ->
              # Delete endpoints for tables
              %{
                "url" => "/api/v1/base/#{table.name}/{id}",
                "method" => "DELETE",
                "json_schema" => %{},
                "source_table_id" => table.id,
                "query" => nil,
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_confirmation"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_hash"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Delete a #{table.name} by id",
                "query_params_schema" => %{},
                "url_params_schema" => %{
                  "id" => "{id}"
                },
                "body_params_schema" => nil,
                "permissions" => %{
                  "#{table.name}_delete_endpoint" => [
                    "delete"
                  ]
                }
              }
            end)
            |> Enum.map(fn endpoint ->
              EndpointHandler.create_endpoint(user, endpoint)
            end)
        else
          {:error, _reason} -> Logger.info("Admin user not created")
          :error -> Logger.info("Error creating admin user")
        end
    end

  {:error, _} ->
    Logger.info("Creating role")

    with {:ok, role} <-
           BaseContent.seed_role(
             role_fields,
             Ecto.UUID.dump!("00000000-0000-0000-0000-000000000000") |> Ecto.UUID.cast!()
           ),
         {:ok, user} <-
           BaseContent.create_user(%{
             "name" => System.get_env("ADMIN_NAME"),
             "email" => System.get_env("ADMIN_EMAIL"),
             "password" => System.get_env("ADMIN_PASSWORD"),
             "password_confirmation" => System.get_env("ADMIN_PASSWORD"),
             "user_roles" => [%{role_id: "#{role.id}"}]
           }),
         {:ok, user} <- BaseContent.get_user(user.id) do
      Logger.info("Admin user created")
      #  Create default configs in the configs table
      configs = Application.get_all_env(:dynamic)

      # Convert list of tuples to map
      configs = Enum.into(configs, %{})

      # Loop through the map and convert all nested values with convert_to_map function in utils with reduce function
      configs =
        Enum.reduce(configs, %{}, fn {key, value}, acc ->
          key = Atom.to_string(key)
          new_value = Utils.convert_to_map(value)
          Map.put(acc, key, new_value)
        end)

      # Insert the configs into the database
      Enum.each(configs, fn {key, value} ->
        case BaseContent.get_config_by_key(key) do
          {:ok, _} ->
            IO.puts("Config already exists")

          {:error, _} ->
            IO.puts("Creating config")

            BaseContent.create_config(user, %{
              "application" => "dynamic",
              "key" => key,
              "value" => value
            })
        end
      end)

      # Create the endpoints

      # Get the base tables
      tables = BaseStructures.list_tables()

      payload =
        tables
        |> Enum.map(fn table ->
          # Index endpoints for tables
          %{
            "url" => "/api/v1/base/#{table.name}",
            "method" => "GET",
            "json_schema" => %{
              "type" => "object",
              "properties" =>
                Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                  case name do
                    "acl" -> acc
                    "password" -> acc
                    "password_confirmation" -> acc
                    "password_hash" -> acc
                    _ -> Map.put(acc, name, %{"type" => "string"})
                  end
                end)
                |> Map.put("limit", %{"type" => "string"})
                |> Map.put("offset", %{"type" => "string"})
                |> Map.put("order_column", %{"type" => "string"})
                |> Map.put("order_direction", %{"type" => "string"})
                |> Map.put("page", %{"type" => "string"})
                |> Map.put("page_size", %{"type" => "string"}),
              "required" => [
                "limit",
                "offset",
                "order_column",
                "order_direction",
                "page",
                "page_size"
              ],
              "additionalProperties" => false
            },
            "source_table_id" => table.id,
            "query" => %{
              "filters" =>
                table.schema
                |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                  # Create a new map with the column name as the key and the column name in {} as the value
                  case name do
                    "acl" -> acc
                    "password" -> acc
                    "password_confirmation" -> acc
                    "password_hash" -> acc
                    "archived_at" -> Map.put(acc, name, %{"lte" => "{#{name}}"})
                    "deleted_at" -> Map.put(acc, name, %{"lte" => "{#{name}}"})
                    "inserted_at" -> Map.put(acc, name, %{"gte" => "{#{name}}"})
                    "updated_at" -> Map.put(acc, name, %{"gte" => "{#{name}}"})
                    _ -> Map.put(acc, name, "{#{name}}")
                  end
                end),
              "limit" => "{limit}",
              "offset" => "{offset}",
              "preloads" => [],
              "schema" => table.name,
              "sort" => [
                %{
                  "field" => "{order_column}",
                  "order" => "{order_direction}"
                }
              ],
              "page" => "{page}",
              "page_size" => "{page_size}"
            },
            "response_template" => %{
              "fields" =>
                table.schema
                |> Enum.reduce([], fn %{"name" => name}, acc ->
                  acc ++ [name]
                end)
                |> Enum.reject(fn field ->
                  field == "acl"
                end)
                |> Enum.reject(fn field ->
                  field == "password"
                end)
                |> Enum.reject(fn field ->
                  field == "password_confirmation"
                end)
                |> Enum.reject(fn field ->
                  field == "password_hash"
                end)
            },
            "auth_required" => true,
            "rate_limit" => 100,
            #  Change this to false if you want to disable the endpoint TODO: disable this by default
            "enabled" => true,
            "description" => "Get all #{table.name}",
            "query_params_schema" => %{
              "limit" => "{limit}",
              "offset" => "{offset}",
              "order_column" => "{order_column}",
              "order_direction" => "{order_direction}",
              "page" => "{page}",
              "page_size" => "{page_size}"
            },
            "url_params_schema" => %{},
            "body_params_schema" => nil,
            "permissions" => %{
              "#{table.name}_index_endpoint" => [
                "read"
              ]
            }
          }
        end)
        |> Enum.map(fn endpoint ->
          EndpointHandler.create_endpoint(user, endpoint)
        end)

      payload2 =
        tables
        |> Enum.map(fn table ->
          # Show endpoints for tables
          %{
            "url" => "/api/v1/base/#{table.name}/{id}",
            "method" => "GET",
            "json_schema" => %{
              "type" => "object",
              "properties" => %{
                "id" => %{
                  "type" => "string"
                }
              },
              "required" => [],
              "additionalProperties" => false
            },
            "source_table_id" => table.id,
            "query" => %{
              "filters" => %{
                "id" => "{id}"
              },
              "preloads" => [],
              "schema" => table.name,
              "limit" => 1,
              "offset" => 0,
              "sort" => [
                %{
                  "field" => "id",
                  "order" => "asc"
                }
              ]
            },
            "response_template" => %{
              "fields" =>
                table.schema
                |> Enum.reduce([], fn %{"name" => name}, acc ->
                  acc ++ [name]
                end)
                |> Enum.reject(fn field ->
                  field == "acl"
                end)
                |> Enum.reject(fn field ->
                  field == "password"
                end)
                |> Enum.reject(fn field ->
                  field == "password_confirmation"
                end)
                |> Enum.reject(fn field ->
                  field == "password_hash"
                end)
            },
            "auth_required" => true,
            "rate_limit" => 100,
            #  Change this to false if you want to disable the endpoint TODO: disable this by default
            "enabled" => true,
            "description" => "Get a #{table.name} by id",
            "query_params_schema" => %{},
            "url_params_schema" => %{
              "id" => "{id}"
            },
            "body_params_schema" => nil,
            "permissions" => %{
              "#{table.name}_read_endpoint" => [
                "read"
              ]
            }
          }
        end)
        |> Enum.map(fn endpoint ->
          EndpointHandler.create_endpoint(user, endpoint)
        end)

      payload3 =
        tables
        |> Enum.map(fn table ->
          # Create endpoints for tables
          case table.name do
            "users" ->
              %{
                "url" => "/api/v1/base/#{table.name}",
                "method" => "POST",
                "json_schema" => %{
                  "type" => "object",
                  "properties" =>
                    table.schema
                    |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                      Map.put(acc, name, %{
                        "type" => "string"
                      })
                      |> Map.reject(fn {key, _} ->
                        key == "password_hash"
                      end)
                      |> Map.reject(fn {key, _} ->
                        key == "acl"
                      end)
                      |> Map.put("password", %{
                        "type" => "string"
                      })
                      |> Map.put("password_confirmation", %{
                        "type" => "string"
                      })
                      |> Map.put("role_id", %{
                        "type" => "string"
                      })
                    end),
                  "required" => [
                    "email",
                    "password",
                    "password_confirmation",
                    "role_id"
                  ],
                  "additionalProperties" => false
                },
                "source_table_id" => table.id,
                "query" => nil,
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_confirmation"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_hash"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Create a new #{table.name}",
                "query_params_schema" => %{},
                "url_params_schema" => %{},
                "body_params_schema" =>
                  Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                    # merge all the columns into a map with the column name as the key and the column name in {} as the value
                    Map.put(acc, name, "{#{name}}")
                  end)
                  |> Map.put("password", "{password}")
                  |> Map.put("password_confirmation", "{password_confirmation}")
                  |> Map.put("user_roles", [
                    %{
                      "role_id" => "{role_id}"
                    }
                  ]),
                "permissions" => %{
                  "#{table.name}_create_endpoint" => [
                    "create"
                  ]
                }
              }

            _ ->
              %{
                "url" => "/api/v1/base/#{table.name}",
                "method" => "POST",
                "json_schema" => %{
                  "type" => "object",
                  "properties" =>
                    table.schema
                    |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                      Map.put(acc, name, %{
                        "type" => "string"
                      })
                      |> Map.reject(fn {key, _} ->
                        key == "acl"
                      end)
                    end),
                  "required" => [],
                  "additionalProperties" => false
                },
                "source_table_id" => table.id,
                "query" => nil,
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Create a new #{table.name}",
                "query_params_schema" => %{},
                "url_params_schema" => %{},
                "body_params_schema" =>
                  Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                    # merge all the columns into a map with the column name as the key and the column name in {} as the value
                    Map.put(acc, name, "{#{name}}")
                  end),
                "permissions" => %{
                  "#{table.name}_create_endpoint" => [
                    "create"
                  ]
                }
              }
          end
        end)
        |> Enum.map(fn endpoint ->
          EndpointHandler.create_endpoint(user, endpoint)
        end)

      payload4 =
        tables
        |> Enum.map(fn table ->
          case table.name do
            "users" ->
              # Update endpoints for tables
              %{
                "url" => "/api/v1/base/#{table.name}/{id}",
                "method" => "PUT",
                "json_schema" => %{
                  "type" => "object",
                  "properties" =>
                    table.schema
                    |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                      Map.put(acc, name, %{
                        "type" => "string"
                      })
                      |> Map.reject(fn {key, _} ->
                        key == "password_hash"
                      end)
                      |> Map.reject(fn {key, _} ->
                        key == "acl"
                      end)
                      |> Map.put("password", %{
                        "type" => "string"
                      })
                      |> Map.put("password_confirmation", %{
                        "type" => "string"
                      })
                      |> Map.put("role_id", %{
                        "type" => "string"
                      })
                    end),
                  "required" => [
                    "email",
                    "password",
                    "password_confirmation",
                    "role_id"
                  ],
                  "additionalProperties" => false
                },
                "source_table_id" => table.id,
                "query" => nil,
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_confirmation"
                    end)
                    |> Enum.reject(fn field ->
                      field == "password_hash"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Update a #{table.name} by id",
                "query_params_schema" => %{},
                "url_params_schema" => %{
                  "id" => "{id}"
                },
                "body_params_schema" =>
                  Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                    # merge all the columns into a map with the column name as the key and the column name in {} as the value
                    Map.put(acc, name, "{#{name}}")
                  end)
                  |> Map.put("password", "{password}")
                  |> Map.put("password_confirmation", "{password_confirmation}")
                  |> Map.put("user_roles", [
                    %{
                      "role_id" => "{role_id}"
                    }
                  ]),
                "permissions" => %{
                  "#{table.name}_update_endpoint" => [
                    "update"
                  ]
                }
              }

            _ ->
              # Update endpoints for tables
              %{
                "url" => "/api/v1/base/#{table.name}/{id}",
                "method" => "PUT",
                "json_schema" => %{
                  "type" => "object",
                  "properties" =>
                    table.schema
                    |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
                      Map.put(acc, name, %{
                        "type" => "string"
                      })
                      |> Map.reject(fn {key, _} ->
                        key == "acl"
                      end)
                    end),
                  "required" => [],
                  "additionalProperties" => false
                },
                "source_table_id" => table.id,
                "query" => nil,
                "response_template" => %{
                  "fields" =>
                    table.schema
                    |> Enum.reduce([], fn %{"name" => name}, acc ->
                      acc ++ [name]
                    end)
                    |> Enum.reject(fn field ->
                      field == "acl"
                    end)
                },
                "auth_required" => true,
                "rate_limit" => 100,
                #  Change this to false if you want to disable the endpoint TODO: disable this by default
                "enabled" => true,
                "description" => "Update a #{table.name} by id",
                "query_params_schema" => %{},
                "url_params_schema" => %{
                  "id" => "{id}"
                },
                "body_params_schema" =>
                  Enum.reduce(table.schema, %{}, fn %{"name" => name}, acc ->
                    # merge all the columns into a map with the column name as the key and the column name in {} as the value
                    Map.put(acc, name, "{#{name}}")
                  end),
                "permissions" => %{
                  "#{table.name}_update_endpoint" => [
                    "update"
                  ]
                }
              }
          end
        end)
        |> Enum.map(fn endpoint ->
          EndpointHandler.create_endpoint(user, endpoint)
        end)

      payload5 =
        tables
        |> Enum.map(fn table ->
          # Delete endpoints for tables
          %{
            "url" => "/api/v1/base/#{table.name}/{id}",
            "method" => "DELETE",
            "json_schema" => %{},
            "source_table_id" => table.id,
            "query" => nil,
            "response_template" => %{
              "fields" =>
                table.schema
                |> Enum.reduce([], fn %{"name" => name}, acc ->
                  acc ++ [name]
                end)
                |> Enum.reject(fn field ->
                  field == "acl"
                end)
                |> Enum.reject(fn field ->
                  field == "password"
                end)
                |> Enum.reject(fn field ->
                  field == "password_confirmation"
                end)
                |> Enum.reject(fn field ->
                  field == "password_hash"
                end)
            },
            "auth_required" => true,
            "rate_limit" => 100,
            #  Change this to false if you want to disable the endpoint TODO: disable this by default
            "enabled" => true,
            "description" => "Delete a #{table.name} by id",
            "query_params_schema" => %{},
            "url_params_schema" => %{
              "id" => "{id}"
            },
            "body_params_schema" => nil,
            "permissions" => %{
              "#{table.name}_delete_endpoint" => [
                "delete"
              ]
            }
          }
        end)
        |> Enum.map(fn endpoint ->
          EndpointHandler.create_endpoint(user, endpoint)
        end)
    else
      {:error, _reason} -> Logger.info("Admin user not created")
      :error -> Logger.info("Error creating admin user")
    end

  _ ->
    Logger.info("Error creating role")
end

# Stop the repo
# Repo.stop()
