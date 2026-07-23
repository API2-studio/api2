## **API2 — `view` Table**

The `view` base endpoint lets you save a reusable, pre-built query (joins, filters, field selection) under a name, so you don't have to reconstruct the same [[data]] `encoded` query and `schema` every time.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/view` | Get the view structure |
| POST | `/api/v1/view` | Create / Read / Update / Delete a view (via `action`) |

### **Schema**

| Field | Description |
|---|---|
| `id` | View id (uuid) |
| `name` | The view's name |
| `table` | The base table the view is built on |
| `encoded` | The encoded join/filter query (same format as [[data]]'s `encoded` param) |
| `schema` | Field selection/aliasing for the view's output, same shape as [[data]]'s `schema` — supports `field` (direct column) or `subquery` (nested lookup) |

### **Create a View — `action: "create"`**

```json
{
  "action": "create",
  "type": "view",
  "body": {
    "name": "todos_doing",
    "table": "users",
    "encoded": "queryType=join^joinType=inner^tableReference=todos^targetColumn=todos.user_id^localColumn=users.id^groupedBy=todos.status_id$todos.id$users.updated_at$users.id$users.name$todos.action$users^%users.id=todos.user_id*AND*%users.name=super_admin*AND*&&queryType=join^joinType=inner^tableReference=status^targetColumn=status.id^localColumn=todos.status_id^groupedBy=status.name$users.name$status.id^%status.enum=3",
    "schema": [
      { "name": "id", "field": "todos.id" },
      { "name": "todo", "field": "todos.action" },
      { "name": "status", "subquery": "subqueryType=object^tableReference=status^targetColumns=status^%status.id=todos.status_id" },
      { "name": "user", "field": "users.name" }
    ]
  }
}
```

### **Read a View**

```json
{ "action": "read", "type": "view", "body": { "id": "8902-1381-1238-1238" } }
```

### **Update a View**

Same body shape as create, plus the view's `id`:

```json
{
  "action": "update",
  "type": "view",
  "body": {
    "id": "11312-12112-12121-12121",
    "table": "users",
    "encoded": "queryType=join^...",
    "schema": [
      { "name": "todos_id", "field": "todos.id" },
      { "name": "status", "subquery": "subqueryType=object^tableReference=status^targetColumns=status^%status.id=todos.status_id" }
    ]
  }
}
```

### **Delete a View**

```json
{ "action": "delete", "type": "view", "body": { "id": "8902-1381-1238-1238" } }
```

### **Responses**

`200` (Read table request), `403` (Table not found — `View Error Not Found Response`).

### **Notes**

- `schema` entries can use `field` for a direct column reference or `subquery` for a nested lookup against another table.
- Views are the recommended way to "save" a complex [[data]] `encoded` query for reuse — build and test the query directly against `/api/v1/data` first, then persist it here once it's right.

---
See also: [[General]], [[data]], [[structure]], [[search]].
