## **API2 MCP Server**

The API2 MCP server (`local-mcp`) exposes API2's management and dynamic APIs as tools that can be called directly from an MCP-enabled assistant — no manual `curl`/token handling required. This note focuses on **creating endpoints**: both custom management endpoints and the tools available for exploring what already exists.

### **Available Tools**

| Tool | Purpose |
|---|---|
| `api2_request` | Call any **base** (management) API endpoint — e.g. `/api/v1/endpoints`, `/api/v1/structure`, `/api/v1/users` |
| `dynamic_request` | Call a **dynamic** table endpoint via `table` name + optional `id`, instead of a raw path |
| `list_dynamic_endpoints` | List all endpoint records currently registered with the DynamicRouter |
| `get_openapi_spec` | Return the OpenAPI spec for `base`, `dynamic`, or `both` |
| `describe_api2_surface` | Return route groups, counts, and a summary of the OpenAPI surface |

### **Creating a New Endpoint**

New endpoints are created through the **base** API's `/api/v1/endpoints` route, called via the `api2_request` tool with `method: POST`.

**Tool call shape:**

```json
{
  "method": "POST",
  "path": "/api/v1/endpoints",
  "body": {
    "url": "/api/v1/endpoint",
    "method": "GET",
    "json_schema": {
      "type": "object",
      "properties": {
        "id": { "type": "string" }
      }
    },
    "source_table_id": "6ce579b1-c6f1-46da-896e-bbab9d422a32",
    "query": { "id": "string" },
    "response_template": { "id": "string" },
    "auth_required": true,
    "rate_limit": 10,
    "enabled": true,
    "description": "This is a test endpoint",
    "query_params_schema": { "id": "string" },
    "url_params_schema": { "id": "string" },
    "body_params_schema": { "id": "string" },
    "permissions": { "id": "string" },
    "acl": { "id": "string" }
  }
}
```

**Field reference:**

- `url` — the path the new endpoint will be served at
- `method` — HTTP verb for the new endpoint (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`)
- `json_schema` — JSON Schema describing the endpoint's overall shape/parameters
- `source_table_id` — the table (structure) this endpoint reads/writes against
- `query` — the underlying query definition executed against the source table
- `response_template` — shapes the response payload
- `auth_required` — whether a bearer token is required to call it
- `rate_limit` — requests-per-window limit
- `enabled` — whether the endpoint is currently live
- `description` — human-readable summary
- `query_params_schema` / `url_params_schema` / `body_params_schema` — schemas for each parameter location
- `permissions` / `acl` — access control configuration

Before creating an endpoint you'll usually need a `source_table_id` — get this from `/api/v1/structure` (`api2_request`, `GET`) or by inspecting an existing table.

### **Reading, Updating, and Deleting Endpoints**

All via `api2_request` against `/api/v1/endpoints`:

```json
// List all endpoints (paginated, filterable, sortable)
{ "method": "GET", "path": "/api/v1/endpoints", "query": { "page_number": 1, "page_size": 10 } }

// Get a single endpoint
{ "method": "GET", "path": "/api/v1/endpoints/{id}" }

// Update an endpoint (same body shape as create)
{ "method": "PUT", "path": "/api/v1/endpoints/{id}", "body": { "...": "..." } }

// Delete an endpoint
{ "method": "DELETE", "path": "/api/v1/endpoints/{id}" }
```

**Available filters for listing** (as query params, e.g. `filters[url]=...`):
- `filters[url]` — filter by URL
- `filters[method]` — filter by HTTP method
- `filters[source_table_id]` — filter by source table
- `filters[query][schema]` — filter where the query's schema field matches (string fields only)

**Available sort options:** `sort[field]` + `sort[order]` (`asc`/`desc`) — sortable by any response field.

**Response fields:** `id`, `url`, `method`, `json_schema`, `source_table_id`, `query`, `response_template`, `auth_required`, `rate_limit`, `enabled`, `description`, `query_params_schema`, `url_params_schema`, `body_params_schema`, `permissions`.

### **Working with Dynamic (Table) Endpoints**

Rather than crafting a raw `/api/v1/dynamic/{table}` path, use `dynamic_request` directly:

```json
// List records
{ "method": "GET", "table": "channels" }

// Get one record
{ "method": "GET", "table": "channels", "id": "1b657907-93ad-4be9-8bc6-efd88d50a6d3" }

// Create a record
{ "method": "POST", "table": "channels", "body": { "name": "general", "topic": "..." } }

// Update / delete follow the same pattern with PATCH|PUT / DELETE + id
```

Use `list_dynamic_endpoints` first to see what's already registered for a table (it returns each endpoint's `json_schema`, required params, `source_table_id`, and whether `auth_required`) before creating a duplicate or conflicting one.

### **Discovering the Surface Before You Build**

Two read-only tools help you understand what already exists before adding a new endpoint:

- **`describe_api2_surface`** — quick summary: route groups, endpoint counts (base vs. dynamic), tables covered
- **`get_openapi_spec`** (`mode: "base" | "dynamic" | "both"`) — full OpenAPI documents, useful for checking exact request/response schemas, required fields, and existing path conflicts

**Recommended workflow when creating a new endpoint:**
1. `describe_api2_surface` — orient yourself on what route groups/tables exist
2. `api2_request` `GET /api/v1/structure` — find the `source_table_id` you need
3. `list_dynamic_endpoints` or `get_openapi_spec` (`dynamic`) — confirm the URL/method you want isn't already taken
4. `api2_request` `POST /api/v1/endpoints` — create it
5. `api2_request` `GET /api/v1/endpoints/{id}` — verify it was created as expected

---

See also: [[General]], [[Introduction]], and `Functions/Create Data.md` for the equivalent workflow on the data layer rather than the endpoint layer.
