# RUN TIME CONFIG
import Config
alias Dynamic.Converter

config :dynamic, Dynamic.Repo,
  username: System.fetch_env!("POSTGRES_USER"),
  password: System.fetch_env!("POSTGRES_PASSWORD"),
  database: System.fetch_env!("POSTGRES_DB"),
  hostname: System.fetch_env!("POSTGRES_HOST"),
  port: System.fetch_env!("POSTGRES_PORT"),
  pool_size: 10,
  timezone: "UTC",
  migration_timestamps: [type: :utc_datetime, time_zone: "UTC"],
  timestamps: [extended: true, abbrev: true]

config :dynamic, ecto_repos: [Dynamic.Repo]

config :dynamic, Oban,
  repo: Dynamic.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
      #  Every Minute
      #  {"* * * * *", MyApp.MinuteWorker},
      # Every hour
      {"0 * * * *", Dynamic.Oban.CleanLogs, args: %{delete: "logs"}},
      #  Every day
      #  {"0 0 * * *", MyApp.DailyWorker, max_attempts: 1},
      #  Every Monday
      #  {"0 12 * * MON", MyApp.MondayWorker, queue: :scheduled, tags: ["mondays"]},
      # Daily
      #  {"@daily", MyApp.AnotherDailyWorker}
     ]}
  ],
  queues: [default: 10, events: 10]

config :dynamic, Dynamic.PromEx,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: [
    host: System.fetch_env!("GRAFANA_HOST") || "http://grafana:3000",
    username: System.fetch_env!("GRAFANA_USER") || "admin",  # Authenticate via Basic Auth
    password: System.fetch_env!("GRAFANA_PASSWORD") || "admin",
    upload_dashboards_on_start: System.fetch_env!("GRAFANA_UPLOAD_DASHBOARDS_ON_START") |>  Converter.convert!()
  ],
  metrics_server: :disabled


config :goth,
  json: System.fetch_env!("GCP_CREDENTIALS") |> File.read!(),
  project: System.fetch_env!("GCP_PROJECT_ID"),
  scopes: [System.fetch_env!("GCP_SCOPE")]

config :dynamic, Dynamic.Goth,
  project_id: System.fetch_env!("GCP_PROJECT_ID"),
  scopes: [System.fetch_env!("GCP_SCOPE")]

config :dynamic, Dynamic.Guardian,
  issuer: "dynamic",
  secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY") || "JhuzDzC3qhncUV4Xr+a/j1CCW6RRm66zu+uMbFd2NKcuI5NbfOc9ao1rsJNYTF0/",
  ttl: {System.fetch_env!("GUARDIAN_TTL_IN_MINUTES") |> String.to_integer() || 2999, :minutes},
  token_ttl: %{
    "access" => { System.fetch_env!("ACCESS_TOKEN_TTL_IN_DAYS") |> String.to_integer() || 30, :days},
    "refresh" => { System.fetch_env!("REFRESH_TOKEN_TTL_IN_DAYS") |> String.to_integer() || 90, :days}
  }

config :ueberauth, Ueberauth,
  base_path: "/api/v1/authentication/",
  providers: [
    identity:
      {Ueberauth.Strategy.Identity,
       [
         callback_methods: ["POST"],
         nickname_field: :email,
         param_nesting: "user",
         uid_field: :email
       ]}
  ]

config :waffle,
  storage: Waffle.Storage.Google.CloudStorage,
  bucket: System.fetch_env!("GCP_BUCKET"),
  storage_dir: System.fetch_env!("GCP_STORAGE_DIR"),
  token_fetcher: Dynamic.Goth,
  signed: true,
  signed_url_ttl: 3600000

  config :dynamic, Dynamic.ElasticsearchCluster,
  default_options: [
    timeout: 5_000,
    recv_timeout: 5_000,
    ssl: [
      # If your Elasticsearch cluster uses a self-signed certificate, you may
      # need to disable verification. This is not recommended for production
      # use, but can be useful for testing.
      # See https://hexdocs.pm/httpoison/Httpoison.html#module-ssl-options
      # for more information.
      {:verify, :verify_none}
    ],
    hackney: [basic_auth: {System.fetch_env!("ELASTIC_USER"), System.fetch_env!("ELASTIC_PASS")}, ssl_options: [
      {:verify, :verify_none}
    ]]
  ],
  # The URL where Elasticsearch is hosted on your system
  url: System.fetch_env!("ELASTIC_HOST") || "http://elaticsearch:9200",

  # If your Elasticsearch cluster uses HTTP basic authentication,
  # specify the username and password here:
  username: System.fetch_env!("ELASTIC_USER") || "elastic",
  password: System.fetch_env!("ELASTIC_PASS") || "--i1o-tRLIVf0-KqtFW-",

  # If you want to mock the responses of the Elasticsearch JSON API
  # for testing or other purposes, you can inject a different module
  # here. It must implement the Elasticsearch.API behaviour.
  api: Elasticsearch.API.HTTP,

  # Customize the library used for JSON encoding/decoding.
  json_library: Jason, # or Jason

  # You should configure each index which you maintain in Elasticsearch here.
  # This configuration will be read by the `mix elasticsearch.build` task,
  # described below.
  indexes: %{
  #   # This is the base name of the Elasticsearch index. Each index will be
  #   # built with a timestamp included in the name, like "posts-5902341238".
  #   # It will then be aliased to "posts" for easy querying.
  #   tables: %{
  #     # This file describes the mappings and settings for your index. It will
  #     # be posted as-is to Elasticsearch when you create your index, and
  #     # therefore allows all the settings you could post directly.
  #     settings: "priv/elasticsearch/tables.json",

  #     # This store module must implement a store behaviour. It will be used to
  #     # fetch data for each source in each indexes' `sources` list, below:
  #     store: Dynamic.Elasticsearch.ElasticsearchStore,

  #     # This is the list of data sources that should be used to populate this
  #     # index. The `:store` module above will be passed each one of these
  #     # sources for fetching.
  #     #
  #     # Each piece of data that is returned by the store must implement the
  #     # Elasticsearch.Document protocol.
  #     sources: [Dynamic.Structures.Table, Dynamic.Structures.View, Dynamic.Structures.Record, Dynamic.Structures.Document],

  #     # When indexing data using the `mix elasticsearch.build` task,
  #     # control the data ingestion rate by raising or lowering the number
  #     # of items to send in each bulk request.
  #     bulk_page_size: 5000,

  #     # Likewise, wait a given period between posting pages to give
  #     # Elasticsearch time to catch up.
  #     bulk_wait_interval: 15_000, # 15 seconds

  #     # By default bulk indexing uses the "create" action. To allow existing
  #     # documents to be replaced, use the "index" action instead.
  #     bulk_action: "index"
  #   },
  #   views: %{
  #     settings: "priv/elasticsearch/views.json",
  #     store: Dynamic.ElasticsearchStore,
  #     sources: [Dynamic.View],
  #     bulk_page_size: 5000,
  #     bulk_wait_interval: 15_000,
  #     bulk_action: "index"
  #   },
  #   records: %{
  #     settings: "priv/elasticsearch/records.json",
  #     store: Dynamic.Elasticsearch.ElasticsearchStore,
  #     sources: [Dynamic.Record],
  #     bulk_page_size: 5000,
  #     bulk_wait_interval: 15_000,
  #     bulk_action: "create"
  #   },
    documents: %{
      settings: "priv/elasticsearch/documents.json",
      store: Dynamic.Elasticsearch.ElasticsearchStore,
      sources: [Dynamic.Structures.Document],
      bulk_page_size: 5000,
      bulk_wait_interval: 15_000,
      bulk_action: "index"
    },
    tables: %{
      settings: "priv/elasticsearch/tables.json",
      store: Dynamic.Elasticsearch.ElasticsearchStore,
      sources: [Dynamic.Structures.Table],
      bulk_page_size: 5000,
      bulk_wait_interval: 15_000,
      bulk_action: "index"
    },
    views: %{
      settings: "priv/elasticsearch/views.json",
      store: Dynamic.Elasticsearch.ElasticsearchStore,
      sources: [Dynamic.Structures.View],
      bulk_page_size: 5000,
      bulk_wait_interval: 15_000,
      bulk_action: "index"
    },
    records: %{
      settings: "priv/elasticsearch/records.json",
      store: Dynamic.Elasticsearch.ElasticsearchStore,
      sources: [Dynamic.Structures.Record],
      bulk_page_size: 5000,
      bulk_wait_interval: 15_000,
      bulk_action: "index"
    }
  }


config :reverse_proxy_plug, :http_client, ReverseProxyPlug.HTTPClient.Adapters.Finch
  # END RUN TIME CONFIG
