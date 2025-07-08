# RUN TIME CONFIG
import Config
alias Dynamic.Converter

config :dynamic, ecto_repos: [Dynamic.Repo, Dynamic.ObanRepo]


config :dynamic, Dynamic.Repo,
  database: System.fetch_env!("POSTGRES_DB") || "canopus",
  username: System.fetch_env!("POSTGRES_USER") || "postgres",
  password: System.fetch_env!("POSTGRES_PASSWORD") || "postgres",
  hostname: System.fetch_env!("POSTGRES_HOST") || "database",
  port: System.fetch_env!("POSTGRES_PORT") || 5432,
  timezone: "UTC",
  migration_timestamps: [type: :utc_datetime, time_zone: "UTC"],
  migration_primary_key: [type: :uuid, name: :id],
  migration_foreign_key: [column: :id, type: :uuid],
  timestamps: [extended: true, abbrev: true],
  pool_size: 20,
  timeout: 30_000,
  queue_target: 50, # Reduce queue wait times
  queue_interval: 1_000 # Lower queue timeout


config :dynamic, Dynamic.ObanRepo,
  database: "dynamic_oban",
  username: System.fetch_env!("POSTGRES_USER") || "postgres",
  password: System.fetch_env!("POSTGRES_PASSWORD") || "postgres",
  hostname: System.fetch_env!("POSTGRES_HOST") || "database",
  port: System.fetch_env!("POSTGRES_PORT") || 5432,
  pool_size: 20,
  timeout: 30_000,
  queue_target: 50, # Reduce queue wait times
  queue_interval: 1_000 # Lower queue timeout


config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 5, cleanup_interval_ms: 60_000]}

config :dynamic, Oban,

  plugins: [
    {Oban.Plugins.Pruner, max_age: 86_400},
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
  queues: [default: 2, events: 2, request_logs: 2, endpoints: 2]



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

config :kafka_ex,
  brokers: [{System.fetch_env!("KAFKA_BROKER_HOST"), String.to_integer(System.fetch_env!("KAFKA_BROKER_PORT") || "9092")}],  # Or your Kafka host(s)
  kafka_version: System.fetch_env!("KAFKA_VERSION"),          # Match your Kafka broker version
  disable_default_worker: System.fetch_env!("KAFKA_DISABLE_DEFAULT_WORKER") || false,  # Optional: true if you manage your own worker
  sync_timeout: System.get_env("KAFKA_SYNC_TIMEOUT", "5000") |> String.to_integer(),  # Optional: timeout for synchronous operations
  max_retries: System.get_env("KAFKA_MAX_RETRIES", "3") |> String.to_integer()  # Optional: max retries for failed operations

config :dynamic, Dynamic.Vault,
  default: true

config :reverse_proxy_plug, :http_client, ReverseProxyPlug.HTTPClient.Adapters.Finch
  # END RUN TIME CONFIG
