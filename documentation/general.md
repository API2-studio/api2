# API2 General Overview

API2 provides management APIs and configurable data endpoints for building applications around database structures, records, workflows, and access controls. Its frontend provides a visual interface for managing the deployment, and its bundled MCP server exposes tools for working with the API from assistants.

Deploy API2 using the published [Docker Hub image](https://hub.docker.com/r/api2studio/canopus-api) and this repository's Docker Compose configuration or Helm chart. Start with [Getting Started](getting_started.md) for the installation sequence and the [README](../README.md) for configuration details.

## Runtime components

The API runs in the `api` container. The Compose stack includes PostgreSQL, Elasticsearch, Kafka/ZooKeeper, a JavaScript workflow runner, Traefik, and monitoring/logging services. The workflow runner is built inside Docker from the supplied source; users do not need a local Node.js installation to run it.

The API container serves the frontend assets included in its image. Open the deployment root for the frontend rather than assuming a separate `/admin` route. A separately hosted frontend should point to the appropriate API deployment.

This is a configurable runtime stack. Review storage, secrets, networking, and resource requirements before deploying it outside a local development environment.

## Capabilities

| Area | Purpose |
| --- | --- |
| Structures and data | Define tables and relationships, then read and modify records. |
| Endpoints | Register routes with queries, response templates, and access settings. |
| Identity and access | Manage users, roles, groups, and integration clients. |
| Workflows | Configure application workflows and JavaScript actions. |
| Integration | Work with files, search, jobs, events, and webhooks. |
| Discovery | Inspect OpenAPI documents and use MCP tools to explore available routes. |

Availability and behavior depend on the API image, configured services, and permissions. The example deployment does not establish production availability or scaling guarantees.

## API organization

### Management routes

Management APIs use the `/api/v1` prefix. Common route families include:

| Route family | Purpose |
| --- | --- |
| `/api/v1/structure` | Inspect and manage table structures. |
| `/api/v1/data` | Perform data operations using API2's request format. |
| `/api/v1/endpoints` | Manage registered endpoints. |
| `/api/v1/authentication` | User authentication. |
| `/api/v1/users`, `/api/v1/roles`, `/api/v1/groups` | User and access management. |
| `/api/v1/clients` | Manage integration clients. |
| `/api/v1/workflows`, `/api/v1/jobs`, `/api/v1/webhooks` | Workflow and integration operations. |
| `/api/v1/files`, `/api/v1/search`, `/api/v1/views` | Files, search, and views. |
| `/api/v1/mcp` | HTTP MCP endpoint for assistant tools. |

A route family does not imply that every HTTP method is supported. Consult the deployed API schema for each operation's method, request body, and response.

### Dynamic and custom endpoints

Registered endpoints define the paths and methods exposed for data access. Discover them through the dynamic OpenAPI document, `list_dynamic_endpoints`, or the endpoint management API. Do not assume every table has all CRUD routes or that every URL follows `/api/v1/dynamic/{table}`.

The deployment's endpoint and table counts change as structures and routes are added or removed. Use `describe_api2_surface` to inspect the current surface rather than relying on a fixed count in documentation.

### Request schemas

Structure creation and endpoint creation use different request formats:

- Structure operations use the structure request envelope, including `type`, `action`, and `body`. A bare object containing a table name and field list is not a complete structure request.
- Custom endpoint definitions refer to the backing structure with `source_table_id`. Inspect the query and response-template schemas for your release before supplying their values.
- Data requests have their own action and query conventions; see [data operations](data.md).

Use the frontend or inspect the live schemas before making changes. This guide intentionally leaves deployment-specific table definitions to those schemas instead of presenting unchecked creation payloads.

## Authentication

### API2 user sessions

User login uses `POST /api/v1/authentication/identity/callback` with an email and password nested under `user`. The response includes a user bearer token for routes that support user authentication. See [authentication](auth.md) for the request and response shape.

User permissions still determine which operations are allowed. Signing in to the frontend does not automatically configure an external MCP client.

### MCP client keys

To authorize an MCP integration:

1. Sign in to the API2 frontend and open `/clients`.
2. Create an integration client with the required access.
3. Generate its API key from the same page.
4. Configure the assistant to send the key as `x-api-key: <generated-client-api-key>`.

MCP uses the generated client key without a `Bearer` prefix. A client ID, user password, or assistant-provider credential is not a substitute. See [the README authentication walkthrough](../README.md#authenticate-with-api2) and its [Codex](../README.md#connect-codex) and [Claude Code](../README.md#connect-claude-code) sections.

## Discover the running API

The following routes are present in the API router reviewed for this guide. Use your deployment's origin; the local Compose API is at `http://localhost:4000`.

| Path | Purpose |
| --- | --- |
| `/` | Frontend entry point for images containing the UI assets. |
| `/docs` | Management API documentation. |
| `/swaggerui` | Swagger UI for the management specification. |
| `/api/openapi` | Management OpenAPI JSON. |
| `/dynamic_docs` | Dynamic API documentation. |
| `/api/dynamic_openapi` | Dynamic OpenAPI JSON. |
| `/health` | Basic HTTP liveness response. |
| `/api/v1/mcp` | MCP JSON-RPC requests over HTTP POST. |

Download the schemas from your running instance:

```bash
export API2_BASE_URL=http://localhost:4000
curl --fail-with-body --silent --show-error "$API2_BASE_URL/api/openapi" | jq .
curl --fail-with-body --silent --show-error "$API2_BASE_URL/api/dynamic_openapi" | jq .
```

Check that the response is the expected JSON, not frontend HTML returned for an unrecognized path. A successful `/health` response confirms HTTP liveness, not database readiness or the health of every dependency.

Through MCP, begin with `describe_api2_surface`, `get_openapi_spec`, or `list_dynamic_endpoints`. Use `api2_request` for management operations and `dynamic_request` for supported table operations. Authenticate with the generated client key first; see [the MCP initialization check](getting_started.md#7-create-a-client-for-mcp).

## Suggested workflow

1. Start and verify the Docker deployment using [Getting Started](getting_started.md).
2. Sign in to the frontend and review the existing structures and access settings.
3. Inspect the live schema for the operation you want to perform.
4. Create or update a structure through the frontend or the documented management operation.
5. Inspect its registered endpoints and verify the intended request with an authorized identity.
6. If using an assistant, create an API2 client and configure its generated key before calling MCP tools.

## Further documentation

- [Runtime setup and operations](../README.md)
- [Authentication](auth.md), [users](users.md), [roles](roles.md), and [groups](groups.md)
- [Data operations](data.md), [endpoints](endpoints.md), and [views](views.md)
- [Workflows](workflows.md), [jobs](jobs.md), and [webhooks](webhooks.md)
- [Files](files.md), [search](search.md), and [audit](audit.md)
- [MCP tools](mcp.md)
