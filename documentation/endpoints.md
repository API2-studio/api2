## **API2 — `endpoints` Table**

The `endpoints` base table lets you register custom, purpose-built REST endpoints backed by a source table, instead of relying on the generic [[data]] endpoint for everything.

> For the step-by-step "how do I create one via the MCP server" workflow, see [[mcp]]. This note documents the underlying REST API itself.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/endpoints` | List all registered endpoints |
| POST | `/api/v1/endpoints` | Create a new endpoint |
| GET | `/api/v1/endpoints/{id}` | Get a single endpoint |
| PUT | `/api/v1/endpoints/{id}` | Update an endpoint |
| DELETE | `/api/v1/endpoints/{id}` | Delete an endpoint |

### **Schema / Fields**

| Field | Description |
|---|---|
| `id` | Endpoint id |
| `url` | The path this endpoint is served at |
| `method` | HTTP verb (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`) |
| `json_schema` | JSON Schema describing the endpoint's overall shape |
| `source_table_id` | The table this endpoint reads/writes against (from [[structure]]) |
| `query` | The underlying query definition |
| `response_template` | Shapes the response payload |
| `auth_required` | Whether a bearer token is required |
| `rate_limit` | Requests-per-window limit |
| `enabled` | Whether the endpoint is currently live |
| `description` | Human-readable summary |
| `query_params_schema` / `url_params_schema` / `body_params_schema` | Schemas for each parameter location |
| `permissions` | Access control configuration |
| `acl` | (create/update only) Additional access-control list |

### **List Endpoints — `GET /api/v1/endpoints`**

```bash
curl -G "http://localhost:4000/api/v1/endpoints" \
  --data-urlencode "page_number=1" --data-urlencode "page_size=10" \
  -H "authorization: Bearer <token>"
```

**Filters** (as query params):
- `filters[url]=/api/v1/some/url`
- `filters[method]=GET`
- `filters[source_table_id]=<table id>`
- `filters[query][schema]=users` (string fields only)

**Sorting:**
```bash
--data-urlencode "sort[field]=url" --data-urlencode "sort[order]=asc"
```

### **Create Endpoint — `POST /api/v1/endpoints`**

```json
{
  "url": "/api/v1/endpoint",
  "method": "GET",
  "json_schema": { "type": "object", "properties": { "id": { "type": "string" } } },
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
```

### **Get / Update / Delete an Endpoint**

```
GET    /api/v1/endpoints/{id}
PUT    /api/v1/endpoints/{id}   (same body shape as create)
DELETE /api/v1/endpoints/{id}
```

### **Responses**

`200`, `400` (Bad Request), `401` (Unauthorized), `403` (Forbidden), `404` (Not Found), `422` (Unprocessable Entity), `500` (Internal Server Error).

### **Notes**

- You'll need a `source_table_id` before creating an endpoint — get it from `GET /api/v1/structure` (see [[structure]]).
- Custom endpoints are a lighter-weight alternative to hitting [[data]] directly with an `encoded` query every time — bake the query/schema/permissions in once, then just call the new `url`.

---
See also: [[General]], [[mcp]], [[structure]], [[data]], [[view]].
