## **API2 — `groups` Table**

The `groups` base table lets you bundle users together (e.g. a team or department) so permissions can be managed collectively rather than per-user.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/groups` | List all groups |
| POST | `/api/v1/groups` | Create a group |
| GET | `/api/v1/groups/{id}` | Get a single group |
| PUT | `/api/v1/groups/{id}` | Update a group |
| DELETE | `/api/v1/groups/{id}` | Delete a group |

### **Schema**

| Field | Type | Description |
|---|---|---|
| `id` | uuid | The id of the group |
| `name` | string | The name of the group |
| `permissions` | object | Map of resource → allowed actions (optional at group level) |
| `registerable` | boolean | Whether the group can be used to register a new user |
| `inserted_at` / `updated_at` | datetime | Timestamps |
| `archived_at` / `deleted_at` | datetime, nullable | Soft-delete/archive markers |

### **List Groups — `GET /api/v1/groups`**

```json
{
  "data": [
    {
      "id": "12321321-412312-123123-123123",
      "name": "data_admin",
      "permissions": { },
      "registerable": true
    }
  ]
}
```

### **Create Group — `POST /api/v1/groups`**

Minimal request:

```json
{ "name": "data_admin" }
```

Response:

```json
{
  "id": "12321321-412312-123123-123123",
  "name": "data_admin",
  "inserted_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z",
  "archived_at": null,
  "deleted_at": null
}
```

### **Get a Group — `GET /api/v1/groups/{id}`**

```json
{ "data": { "id": "...", "name": "data_admin", "permissions": { }, "registerable": true } }
```

### **Update a Group — `PUT /api/v1/groups/{id}`**

```json
{ "id": "...", "name": "data_admin" }
```

### **Delete a Group — `DELETE /api/v1/groups/{id}`**

```json
{ "id": "..." }
```
Response: `{ "data": { "id": "...", "deleted": true } }`

### **Errors**

```json
{ "errors": [ { "message": "Name has already been taken", "field": "name" } ] }
```

Responses: `200`, `401` (Unauthorized), `403` (Not found).

### **Notes**

- Groups relate to users through the `group_roles` / `user_groups` dynamic tables (visible via `describe_api2_surface` / `list_dynamic_endpoints` in the MCP server — see [[mcp]]).
- Use groups when permissions need to apply to many users at once; use [[roles]] for permission sets attached directly to a single user.

---
See also: [[General]], [[roles]], [[users]].
