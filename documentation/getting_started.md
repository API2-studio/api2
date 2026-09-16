# Getting Started with API2

This guide takes you from a fresh checkout to a running API2 deployment and an authenticated MCP connection. Deploy the API using the published [Docker Hub image](https://hub.docker.com/r/api2studio/canopus-api). You do not need to install an API2 executable, Elixir, Node.js, or npm on your host for this workflow.

The [README](../README.md) is the reference for environment values, assistant configuration, and deployment operations. This guide follows the same setup sequence.

## 1. Check prerequisites

Install Git, Docker Engine or Docker Desktop with Docker Compose v2, OpenSSL, `curl`, and `jq`. Use Bash for the shell examples; Windows users can run them through WSL.

```bash
git --version
docker --version
docker compose version
openssl version
jq --version
```

Start Docker and allocate enough resources for the complete stack. Elasticsearch alone has a 4 GB JVM heap and an 8 GB memory limit in the supplied configuration. Check [the Compose file](../docker-compose.yml) for published ports and host mounts before starting another deployment on the same machine.

## 2. Clone the deployment repository

```bash
git clone https://github.com/API2-studio/api2.git
cd api2
```

Run the remaining Compose commands from this directory. The repository supplies the runtime configuration; Docker downloads the API image. Only the separate JavaScript workflow runner is built locally, inside Docker, from `workflow-js/`.

## 3. Choose an image and configure the environment

Choose a published version from [Docker Hub tags](https://hub.docker.com/r/api2studio/canopus-api/tags). Pin that version for a repeatable deployment. To use the default moving tag:

```bash
export API_IMAGE=api2studio/canopus-api:latest
```

You can also set `API_IMAGE` in `.env`; an exported shell value takes precedence.

Edit the supplied root `.env` using the [README environment reference](../README.md#3-create-the-environment-file). If your checkout does not contain `.env`, create it using that example. Replace example credentials and project-specific values before starting.

Check these settings in particular:

| Configuration | What to set |
| --- | --- |
| Database | Configure both `POSTGRES_*` and `OBAN_POSTGRES_*`, including their pool sizes. Containers connect to `database:5432`; host tools use port `7432`. |
| Administrator | Set `ADMIN_NAME`, `ADMIN_EMAIL`, and `ADMIN_PASSWORD` for initialization. Existing accounts may retain their previous credentials. |
| Application secrets | Generate strong values for `GUARDIAN_SECRET_KEY` and `SECRET_KEY_BASE`. |
| Workflow runner | Set `WORKFLOW_JS_RUNNER_SECRET` to a secret of at least 32 characters, shared by the API and runner. Compose passes the same value to both. |
| Cloud storage | Configure the GCP project, bucket, scope, and service-account credentials for the supplied storage setup. |
| Kafka | Use `kafka:29092` for communication between containers. |
| MCP | Set `MCP_API2_BASE_URL=http://localhost:4000` for requests from the bundled MCP server back to this API process. |

Run `openssl rand -hex 64` separately for each application secret. Keep `.env` private and do not commit your deployment credentials. Grafana and Elasticsearch also have service-level settings in Compose; changing the API's environment values alone does not reconfigure those services.

## 4. Prepare the secret files

```bash
mkdir -p secrets
```

Place your GCP service-account JSON at `secrets/application_default_credentials.json`. Create the encryption key once for a new deployment:

```bash
# Refuses to overwrite an existing key.
(umask 077; set -C; openssl rand -base64 32 > secrets/cloak_key)
chmod 600 .env secrets/application_default_credentials.json secrets/cloak_key
```

The expected files are:

```text
secrets/
├── application_default_credentials.json
└── cloak_key
```

Compose mounts them read-only into the API container. Keep the encryption key with your backups and reuse it when restoring existing encrypted data. See [mounted secrets](../README.md#4-prepare-the-mounted-secrets) for the container paths.

## 5. Pull the images and start the stack

```bash
docker compose config --quiet
docker compose pull
docker compose build workflow-js
docker compose up -d
docker compose ps
docker compose logs --tail=100 api
```

Wait for the dependencies to become healthy and API initialization to finish. If startup fails, inspect the logs before continuing; see [troubleshooting](../README.md#troubleshooting), including the separate Oban database requirement.

## 6. Verify the API and open the frontend

Check the API directly, without relying on proxy routing:

```bash
curl --fail-with-body --silent --show-error http://localhost:4000/health | jq .
```

Expect `{"status":"ok"}`. This checks that the HTTP process responds; it does not prove every dependency or workflow is healthy.

Open the frontend at [localhost:4000](http://localhost:4000), or [localhost](http://localhost) through the supplied Traefik route, and sign in with your deployment's API2 account. If you host the frontend separately, use that frontend's address instead.

Inspect the running API's documentation:

- [Management API documentation](http://localhost:4000/docs)
- [Swagger UI](http://localhost:4000/swaggerui)
- [Dynamic API documentation](http://localhost:4000/dynamic_docs)

These links point to your local deployment. Replace the origin for a remote installation.

## 7. Create a client for MCP

1. Open `/clients` in the API2 frontend while signed in with an account permitted to manage clients.
2. Create a client for the integration, such as `Codex development` or `Claude development`, and configure its access.
3. Generate the client's API key from that page and store it securely.
4. Use that generated key in the `x-api-key` header on MCP requests. Do not use the client ID or add a `Bearer` prefix.

In Bash, enter the key without putting it in your shell history:

```bash
export API2_BASE_URL=http://localhost:4000
export API2_MCP_URL="$API2_BASE_URL/api/v1/mcp"
read -r -s -p 'API2 client API key: ' API2_API_KEY
printf '\n'
export API2_API_KEY
```

Verify MCP initialization:

```bash
curl --fail-with-body --silent --show-error "$API2_MCP_URL" \
  -H "x-api-key: $API2_API_KEY" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"api2-setup-check","version":"1.0"}}}' |
  jq .
```

A successful response contains `result.serverInfo` and `result.capabilities`. An HTTP `200` containing a JSON-RPC `error` is not success. A browser GET to the MCP URL is not an initialization request.

## 8. Connect your assistant and inspect the API

Follow the README's [Codex configuration](../README.md#connect-codex) or [Claude Code configuration](../README.md#connect-claude-code). Both send the generated client key through `x-api-key`. Start the assistant with `API2_API_KEY` available in its environment; the project's `.env` is not automatically loaded by either assistant.

Try this first:

> Use api2_mcp to describe the API2 surface and list the available dynamic endpoints. Do not modify any data.

Then inspect the structure and endpoint schemas before creating your first table or custom endpoint. The available routes depend on the deployed image and registered structures; use the live OpenAPI documents or MCP discovery tools rather than assuming a fixed endpoint list.

## Next steps

- [General API overview](general.md): API organization, authentication, and discovery.
- [MCP tool guide](mcp.md): tool usage and endpoint operations.
- [Operations](../README.md#operate-the-stack): logs, upgrades, rollback, and stopping the stack.
- [Kubernetes deployment](../README.md#deploy-with-kubernetes): Helm configuration and GKE guidance.

To stop the local stack while retaining named volumes:

```bash
docker compose down
```

Adding `-v` removes named volumes and can destroy stored data.
