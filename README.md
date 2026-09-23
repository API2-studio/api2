# API2 Runtime Stack

Run API2 with Docker Compose or Kubernetes, and connect AI assistants to its built-in Model Context Protocol (MCP) server. API2 exposes management and dynamic data APIs for working with structures, records, endpoints, workflows, and access controls.

This repository contains deployment configuration and API documentation. The API runs from the published `api2studio/canopus-api` image; the JavaScript workflow runner runs from the published `api2studio/workflow-sandbox` image.

## Contents

- [Prerequisites](#prerequisites)
- [Set up the runtime](#set-up-the-runtime)
- [Authenticate with API2](#authenticate-with-api2)
- [Configure the MCP server](#configure-the-mcp-server)
- [Connect Codex](#connect-codex)
- [Connect Claude Code](#connect-claude-code)
- [Verify and use the integration](#verify-and-use-the-integration)
- [Operate the stack](#operate-the-stack)
- [Deploy with Kubernetes](#deploy-with-kubernetes)
- [Troubleshooting](#troubleshooting)
- [Documentation](#documentation)

## Prerequisites

Install Git, Docker Engine or Docker Desktop with Docker Compose v2, `curl`, OpenSSL, and `jq`. The examples use Bash on macOS, Linux, or Windows through WSL. Codex and Claude Code also require their own accounts or supported provider credentials.

```bash
git --version
docker --version
docker compose version
jq --version
```

Start Docker before continuing. Allocate enough memory for the complete stack: Elasticsearch alone is configured with a 4 GB JVM heap and an 8 GB memory limit. The Compose file also starts PostgreSQL, Kafka/ZooKeeper, monitoring, logging, and proxy services.

Check for port conflicts, especially `80`, `4000`, `3000`, `7432`, and `9200`. See [docker-compose.yml](docker-compose.yml) for all published ports. This is an example environment: Elasticsearch security is disabled and several infrastructure ports are exposed. Review those settings before deploying to a shared or public host.

## Set up the runtime

### 1. Clone the repository

```bash
git clone https://github.com/API2-studio/api2.git
cd api2
```

Run subsequent Compose commands from this directory.

### 2. Select the runtime images

Set `API_IMAGE` in `.env` or export it in your shell. Choose a published tag from [Docker Hub](https://hub.docker.com/r/api2studio/canopus-api/tags) for reproducible deployments. If omitted, Compose uses `api2studio/canopus-api:latest`.

```bash
export API_IMAGE=api2studio/canopus-api:latest
```

A shell export overrides the value in `.env`. Use an API release that includes `/api/v1/mcp`; older images may not provide the same MCP tools or authentication behavior.

Set `WORKFLOW_JS_IMAGE` in `.env` or export it in your shell to select the workflow runner image. If omitted, Compose uses `api2studio/workflow-sandbox:latest`. The runner's shared secret is supplied at container startup through `WORKFLOW_JS_RUNNER_SECRET`.

### 3. Create the environment file

`.env` is supplied as an example. With example values. Update it in the repository root, or update your existing file without discarding deployment-specific values. The following is a starting configuration for the Compose service names. Replace every `replace-*` value before starting. Most of the ENV values specified in the example are required for the API to start successfully. The workflow runner requires the same `WORKFLOW_JS_RUNNER_SECRET` value in the API and runner containers, with at least 32 characters. Compose supplies that shared value from `.env`; it does not need to equal `SECRET_KEY_BASE`.

```dotenv
COMPOSE_PROJECT_NAME=dynamic
API_IMAGE=api2studio/canopus-api:latest
WORKFLOW_JS_IMAGE=api2studio/workflow-sandbox:latest

POSTGRES_USER=postgres
POSTGRES_PASSWORD=replace-database-password
POSTGRES_DB=canopus
POSTGRES_HOST=database
POSTGRES_PORT=5432
DB_POOL_SIZE=10

OBAN_POSTGRES_USER=postgres
OBAN_POSTGRES_PASSWORD=replace-database-password
OBAN_POSTGRES_DB=oban_canopus
OBAN_POSTGRES_HOST=database
OBAN_POSTGRES_PORT=5432
OBAN_POOL_SIZE=5

ADMIN_NAME=Administrator
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=replace-admin-password
GUARDIAN_SECRET_KEY=replace-generated-secret
SECRET_KEY_BASE=replace-generated-secret
ACCESS_TOKEN_TTL_IN_DAYS=7
REFRESH_TOKEN_TTL_IN_DAYS=7

STORAGE_PROVIDER=gcp
GCP_CREDENTIALS=/app/secrets/application_default_credentials.json
CLOAK_KEY=/app/secrets/cloak_key
GCP_PROJECT_ID=replace-project-id
GCP_BUCKET=replace-bucket-name
GCP_SCOPE=https://www.googleapis.com/auth/devstorage.full_control
GCP_STORAGE_DIR=/uploads
GOOGLE_CLIENT_EMAIL=replace-service-account-email
GOOGLE_PROJECT_ID=replace-project-id
GOOGLE_BUCKET_NAME=replace-bucket-name

ELASTIC_HOST=http://elasticsearch:9200
ELASTIC_USER=elastic
ELASTIC_PASS=replace-elasticsearch-password
GRAFANA_HOST=http://grafana:3000
GRAFANA_USER=admin
GRAFANA_PASSWORD=replace-grafana-password
GRAFANA_UPLOAD_DASHBOARDS_ON_START=false

KAFKA_BROKER_HOST=kafka
KAFKA_BROKER_PORT=29092
KAFKA_BROKER_URL=kafka:29092
KAFKA_VERSION=7.4.0
KAFKA_BROKER_SSL=false
WORKFLOW_KAFKA_ENABLED=true
WORKFLOW_KAFKA_PORT=29092
WORKFLOW_KAFKA_TOPIC=workflow_topic
WORKFLOW_KAFKA_GROUP_ID=workflow_group

WORKFLOW_JS_RUNNER_SECRET=replace-generated-secret
WORKFLOW_JS_RUNNER_URL=http://workflow-js:3000/execute
WORKFLOW_JS_RUNNER_TIMEOUT_MS=10000

MCP_API2_BASE_URL=http://localhost:4000
MCP_API2_ALLOWED_METHODS=GET,POST,PUT,PATCH,DELETE
EMAIL_PROVIDER_SENDGRID_ENABLED=false
EMAIL_PROVIDER_MAILGUN_ENABLED=false
```

Generate a separate value for each application secret by running `openssl rand -hex 64`. Generate strong database and administrator passwords as well. Keep `.env` private:

```bash
chmod 600 .env
```

Configuration details:

- `WORKFLOW_JS_RUNNER_SECRET` is required by Compose and shared by the API and workflow runner.
- Use `database:5432` from containers. The host-facing PostgreSQL port is `7432`.
- Use `kafka:29092` between containers; this is Kafka's advertised internal listener.
- The example uses a separate Oban database. Ensure it exists if your selected image does not create it during initialization; see troubleshooting.
- Grafana's initial administrator credentials are set directly in `docker-compose.yml`. Align those settings with `GRAFANA_USER` and `GRAFANA_PASSWORD`; changing API environment values alone does not change Grafana's login. The same distinction applies to Elasticsearch's service settings.
- Configure `GRAFANA_API_KEY` if required by the Grafana integration you enable. Configure mail provider credentials when enabling email delivery.
- Review [Helm values](helm/api2/values.yaml) for additional runtime options, but replace its example credentials and deployment-specific values rather than copying them unchanged.

### 4. Prepare the mounted secrets

```bash
mkdir -p secrets
```

Place a valid GCP service-account JSON file at `secrets/application_default_credentials.json` for the configured project and bucket. Create the encryption key once for a new deployment:

```bash
# Run only if this deployment does not already have a cloak_key.
(umask 077; set -C; openssl rand -base64 32 > secrets/cloak_key)
chmod 600 secrets/application_default_credentials.json secrets/cloak_key
```

Expected layout:

```text
secrets/
├── application_default_credentials.json
└── cloak_key
```

Compose mounts this directory read-only at `/app/secrets` and `/secrets`, and overrides the API's credential and key paths to `/app/secrets/...`. Preserve the encryption key with your backups; replacing it can make existing encrypted data unreadable.

### 5. Validate and start

```bash
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 api
```

Wait for PostgreSQL, Elasticsearch, and the workflow runner to become healthy and for API initialization to finish. The first startup can take longer while images download and the application initializes its data.

| Service | Local address |
| --- | --- |
| API, direct access | `http://localhost:4000` |
| API through Traefik | `http://localhost` |
| MCP endpoint | `http://localhost:4000/api/v1/mcp` |
| Grafana | `http://localhost:3000` |
| PostgreSQL, from your host | `localhost:7432` |
| Kafka UI | `http://localhost:8090/kafka` |

The remaining examples use direct API access to avoid depending on proxy routing.

## Authenticate with API2

MCP uses an API key generated for an API2 client, supplied in the `x-api-key` request header. Signing in to Codex or Claude is separate from authorizing access to API2.

### 1. Create a client and generate its API key

1. Open your API2 frontend and sign in with an account that can manage clients.
2. Navigate to the `/clients` page on that frontend. This is a frontend route, not the MCP URL on port `4000`.
3. Create a client for the integration, using a descriptive name such as `Codex development` or `Claude development`, and configure the access it needs.
4. Generate the API key for that client from the `/clients` page.
5. Copy the generated key and store it securely. Use the generated API key as the header value, rather than the client ID or your API2 account password.

You can create separate clients for Codex and Claude to manage their access independently. If you cannot create a client or generate its key, ask your API2 administrator to provision one.

### 2. Make the key available to your assistant

Run the following in **Bash**, pasting the generated client API key at the hidden prompt:

```bash
export API2_BASE_URL=http://localhost:4000
export API2_MCP_URL="$API2_BASE_URL/api/v1/mcp"

read -r -s -p 'API2 client API key: ' API2_API_KEY
printf '\n'
export API2_API_KEY
```

Send the key as `x-api-key: <generated-client-api-key>`, with no `Bearer` prefix. MCP setup does not require a user login token or an MCP OAuth login.

Keep the key out of committed configuration and assistant prompts. Exported variables apply to the current shell and its child processes; Docker's `.env` is not automatically loaded by either assistant. After replacing or regenerating the client key, update `API2_API_KEY` and restart the assistant.

## Configure the MCP server

The MCP server ships inside the API process. Configure clients as HTTP MCP connections using `/api/v1/mcp`; no additional MCP container or local stdio package is required. This guide registers it under the client-side name `api2_mcp`.

| Setting | Purpose |
| --- | --- |
| `MCP_API2_BASE_URL` | API URL called by MCP tools from inside the API container. For this stack, use `http://localhost:4000`. Do not append `/api/v1/mcp`. |
| `MCP_API2_ALLOWED_METHODS` | Comma-separated HTTP methods allowed by the API proxy tools. |
| `MCP_API2_ALLOWED_PATH_PREFIXES` | Optional comma-separated path allowlist. Leave unset to use the release defaults, or explicitly restrict accessible routes. |

Use the `MCP_API2_*` spelling. Similarly named `MCP_API_*` variables are not the settings used by the server implementation reviewed for this guide. The client-facing URL and the container's internal API URL serve different purposes; on a remote deployment, clients need a reachable HTTPS URL.

After changing server environment values:

```bash
docker compose up -d api
```

Verify authenticated MCP initialization:

```bash
curl --fail-with-body --silent --show-error "$API2_MCP_URL" \
  -H "x-api-key: $API2_API_KEY" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"api2-setup-check","version":"1.0"}}}' |
  jq .
```

Expect a JSON-RPC `result` containing `protocolVersion`, `capabilities`, and `serverInfo`. An HTTP `200` with a JSON-RPC `error` is not a successful initialization. Opening the endpoint in a browser sends a GET and is not a valid MCP connectivity test.

## Connect Codex

### 1. Install and sign in

For macOS or Linux, install the CLI and launch it:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
codex --version
codex
```

Complete the assistant account sign-in, then exit to your shell. See the [official Codex installation guide](https://developers.openai.com/codex/cli) for other platforms.

### 2. Register API2

Merge the following into `~/.codex/config.toml`. If `api2_mcp` already exists, update that section instead of adding a duplicate. Remove any old `bearer_token_env_var`, `Authorization` header, or OAuth configuration for this server.

```toml
[mcp_servers.api2_mcp]
url = "http://localhost:4000/api/v1/mcp"
env_http_headers = { "x-api-key" = "API2_API_KEY" }
```

`env_http_headers` maps the HTTP header name to the environment variable containing its value. Replace the URL with your deployment's MCP address when needed. See [Codex MCP configuration](https://developers.openai.com/codex/mcp).

In the shell where you exported `API2_API_KEY`, verify the configuration and start Codex:

```bash
codex mcp list
codex mcp get api2_mcp
codex
```

Use `/mcp` to inspect the connection, then try the read-only verification request below.

For a desktop or IDE process, ensure `API2_API_KEY` is present in that process's environment before it starts, then restart it. A terminal export does not automatically reach an already-running GUI application.

## Connect Claude Code

### 1. Install and sign in

On macOS, Linux, or WSL:

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude --version
claude
```

Follow the account sign-in prompts, then exit to your shell. See the [Claude Code quickstart](https://code.claude.com/docs/en/quickstart) for other platforms and account options.

### 2. Register API2

Run this from the project directory. If a local `api2_mcp` entry already exists, remove it with `claude mcp remove api2_mcp --scope local` before adding the updated definition:

```bash
claude mcp add --transport http --scope local api2_mcp \
  "$API2_MCP_URL" --header 'x-api-key: ${API2_API_KEY}'
claude mcp get api2_mcp
```

The single quotes preserve `${API2_API_KEY}` for Claude Code to expand from its environment. Start `claude` in the shell containing the exported client API key. Run `/mcp` and confirm `api2_mcp` connects.

For a shared project configuration, merge the following into `.mcp.json` instead of adding the local entry:

```json
{
  "mcpServers": {
    "api2_mcp": {
      "type": "http",
      "url": "http://localhost:4000/api/v1/mcp",
      "headers": {
        "x-api-key": "${API2_API_KEY}"
      }
    }
  }
}
```

Each developer supplies their own client API key and approves the project server when prompted. A local entry with the same name takes precedence over the project entry. See [Claude Code MCP configuration](https://code.claude.com/docs/en/mcp) for scopes and environment expansion.

## Verify and use the integration

Start with a read-only request in either assistant:

> Use api2_mcp to describe the API2 surface and list the available dynamic endpoints. Do not modify any data.

Core tools include:

| Tool | Purpose |
| --- | --- |
| `describe_api2_surface` | Summarize the exposed API routes. |
| `get_openapi_spec` | Inspect base, dynamic, or combined API schemas. |
| `list_dynamic_endpoints` | Discover registered dynamic endpoints. |
| `api2_request` | Call management API routes such as `/api/v1/structure`. |
| `dynamic_request` | Access a dynamic table by name and optional record ID. |

Available tools depend on the API image. Successful tool discovery does not guarantee permission to read or write every resource: API2 roles, client scopes, and MCP route/method restrictions still apply.

Before asking an assistant to create a table, endpoint, or workflow, have it inspect the existing schema and describe the proposed change. See [the MCP tool guide](documentation/mcp.md) for request examples.

## Operate the stack

### Logs and configuration changes

```bash
docker compose ps
docker compose logs -f --tail=100 api
docker compose logs --tail=100 database elasticsearch workflow-js
```

Use `docker compose up -d` after editing `.env` or Compose configuration; `docker compose restart` alone does not apply changed container environment values.

### Upgrade or roll back

Back up PostgreSQL and retain your encryption key before upgrading. Select a published tag, then run:

```bash
# Replace RELEASE_TAG with the version you intend to deploy.
export API_IMAGE=api2studio/canopus-api:RELEASE_TAG
docker compose pull api
docker compose up -d api
docker compose logs --tail=100 api
```

Repeat the MCP initialization check with your client API key. To return to an earlier image, repeat the commands with the previous tag. An image rollback does not reverse database migrations; check release compatibility before using an older image against upgraded data.

### Stop

```bash
docker compose down
```

Named volumes remain for the next startup. `docker compose down -v` removes named volumes and can destroy stored data; reserve it for an intentional reset of a disposable environment.

## Deploy with Kubernetes

The Helm chart is in [helm/api2](helm/api2). Configure `kubectl` for your cluster and install Helm 3. Review image tags, ingress host, storage, credentials, and resource settings in [values.yaml](helm/api2/values.yaml). Its defaults differ from Compose and include example secrets that must be replaced.

Prepare a private override file outside the repository, then provision the Secrets referenced by it. The default GCP credential reference is `gcp-credentials`, with key `application_default_credentials.json`.

```bash
helm dependency build ./helm/api2
helm upgrade --install api2 ./helm/api2 \
  --namespace api2 --create-namespace \
  -f /path/to/private-values.yaml
kubectl get pods,svc,ingress -n api2
helm status api2 -n api2
```

For GKE, follow [the GCP deployment guide](helm/api2/DEPLOY_GCP.md) and review [values-gcp.yaml](helm/api2/values-gcp.yaml):

```bash
helm upgrade --install api2 ./helm/api2 \
  --namespace api2 --create-namespace \
  -f ./helm/api2/values.yaml \
  -f ./helm/api2/values-gcp.yaml \
  -f /path/to/private-values.yaml
```

Use the reachable HTTPS ingress URL plus `/api/v1/mcp` in your assistant configuration. Supply the generated client API key in the `x-api-key` header for this endpoint as well.

```bash
helm history api2 -n api2
helm rollback api2 REVISION -n api2
# Remove the release only when intended:
helm uninstall api2 -n api2
```

Helm rollback also does not undo database changes. Review persistent-volume retention before uninstalling.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Compose reports `set WORKFLOW_JS_RUNNER_SECRET` | Set a nonempty value in the root `.env`, then run `docker compose config --quiet`. |
| API container exits or keeps restarting | Inspect API and dependency logs. Check required environment values, pool sizes, mounted secrets, and available memory. |
| Oban database does not exist | After PostgreSQL is healthy, create the configured database if absent. For the example settings: `docker compose exec database createdb -U postgres oban_canopus`, then restart the API. Do not recreate an existing database. |
| Database login fails after changing `.env` | An existing PostgreSQL volume retains its original users/passwords; update the database credentials deliberately rather than deleting the volume. |
| API2 login fails | Confirm the deployed user's credentials and the `/api/v1/authentication/identity/callback` body shape. Existing database accounts may differ from bootstrap values. |
| MCP returns `401` | Confirm the key was generated for a client from the API2 frontend `/clients` page and is sent as `x-api-key`, without a `Bearer` prefix. Export `API2_API_KEY` in the assistant’s launch environment and restart it. |
| MCP returns `404` | Check the image version and exact `/api/v1/mcp` path; use a POST initialization request, not a browser GET. |
| Tools connect but API calls fail | Check `MCP_API2_BASE_URL` from the API container's perspective. Confirm user permissions, client scopes, and method/path allowlists. |
| Claude reports an unset variable | Export `API2_API_KEY` before launching Claude; `.env` is not automatically sourced. |
| Grafana login differs from `.env` | Check Compose's `GF_SECURITY_ADMIN_*` values and any existing Grafana volume. |
| Promtail fails on Docker Desktop | Its host mounts assume Linux paths such as `/var/log` and `/etc/machine-id`; adapt the logging service to your host. |

## Documentation

- [Getting Started](documentation/getting_started.md)
- [API conventions and overview](documentation/general.md)
- [Authentication](documentation/auth.md)
- [Users](documentation/users.md), [roles](documentation/roles.md), and [groups](documentation/groups.md)
- [Data operations](documentation/data.md) and [endpoints](documentation/endpoints.md)
- [Workflows](documentation/workflows.md), [webhooks](documentation/webhooks.md), and [jobs](documentation/jobs.md)
- [MCP tools and examples](documentation/mcp.md)
- [GKE deployment](helm/api2/DEPLOY_GCP.md)

## License

This repository includes the [CC0 1.0 Universal dedication](LICENSE). Consult the licenses of the API image and other bundled components separately.
