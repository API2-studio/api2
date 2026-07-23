## **API2 — `roles` Table**

The `roles` base table defines reusable permission sets that can be attached to users (via `user_roles`) to control what they're allowed to do across the API.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/roles` | List all roles |
| POST | `/api/v1/roles` | Create a role |
| GET | `/api/v1/roles/{id}` | Get a single role |
| PUT | `/api/v1/roles/{id}` | Update a role |
| DELETE | `/api/v1/roles/{id}` | Delete a role |

### **Schema**

| Field | Type | Description |
|---|---|---|
| `id` | uuid | The id of the role |
| `name` | string | The name of the role |
| `permissions` | object | Map of resource → allowed actions |
| `registerable` | boolean | Whether this role can be self-assigned at registration |
| `inserted_at` / `updated_at` | datetime | Timestamps |

`permissions` is a map keyed by resource (e.g. `auth`, `tables`) with an array of allowed actions:

```json
{
  "name": "data_admin",
  "permissions": {
    "auth": ["create", "read", "update", "delete"],
    "tables": ["create", "read", "update", "delete"]
  },
  "registerable": true
}
```

### **List Roles — `GET /api/v1/roles`**

```json
{
  "data": [
    {
      "id": "12321321-412312-123123-123123",
      "name": "data_admin",
      "permissions": { "auth": ["create","read","update","delete"], "tables": ["create","read","update","delete"] },
      "registerable": true
    }
  ]
}
```

### **Create Role — `POST /api/v1/roles`**

```json
{
  "name": "data_admin",
  "permissions": {
    "auth": ["create", "read", "update", "delete"],
    "tables": ["create", "read", "update", "delete"]
  },
  "registerable": true
}
```

Response wraps the created role under `"role"`.

### **Get / Update / Delete a Role**

```
GET    /api/v1/roles/{id}
PUT    /api/v1/roles/{id}
DELETE /api/v1/roles/{id}
```

Update/Delete accept the same body shape as create.

### **Errors**

```json
{ "errors": [ { "message": "Name has already been taken", "field": "name" } ] }
```

Responses: `200`, `401` (Unauthorized), `403` (Not found).

### **Notes**

- `name` must be unique per role.
- Assign a role to a user at creation time via `user_roles: [{ "role_id": "<id>" }]` on `POST /api/v1/users` — see [[users]].
- Roles differ from [[groups]]: roles are attached directly to individual users, groups are collections that can hold multiple `group_roles`.

---
See also: [[General]], [[users]], [[groups]], [[authentication]].
