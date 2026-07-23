## **API2 — `data` Table**

The `data` base endpoint is the dynamic CRUD engine for any table's *records* (as opposed to [[structure]], which manages the tables/schemas themselves). It's the most flexible endpoint in the API — supporting pagination, field selection, joins, and post-query reshaping in a single call.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| POST | `/api/v1/data` | Create / Read / Update / Delete records (via `action`) |
| GET | `/api/v1/data/{id}` | Get records for a table by id, with query/join/reshape support |
| PUT | `/api/v1/data/{id}` | Update a record |
| DELETE | `/api/v1/data/{id}` | Delete a record |

### **Parameters**

| Parameter | Type | Where | Description |
|---|---|---|---|
| `id` | string | path/body | The id of the table (or record, depending on action) |
| `page` | integer | query | Page number for pagination |
| `page_size` | integer | query | Records per page |
| `encoded` | string | query/body | Encoded join/filter query (read, update, delete only) |
| `schema` | string/array | query/body | Field-selection schema — reshapes which columns are returned and under what name |
| `script` | string | query/body | A JS post-query reshape function |

### **`POST /api/v1/data` — action-based CRUD**

Body shape:
```json
{
  "type": "data",
  "action": "read",
  "body": {
    "id": "<table id>",
    "schema": [ /* field selection, see below */ ],
    "script": "/* optional reshape function */",
    "encoded": "/* optional encoded join/filter query */"
  }
}
```

`type` can be `data`, `structure`, `schema`, `auth`, or `view`. `action` is one of `create`, `read`, `update`, `delete`.

**`schema` — selecting/aliasing fields:**
```json
[
  { "name": "id", "field": "todos.id" },
  { "name": "action", "field": "todos.action" },
  { "name": "priority", "field": "todos.priority" },
  { "name": "status", "field": "status" },
  { "name": "user", "field": "users.email" },
  { "name": "created_at", "field": "todos.inserted_at" }
]
```

**`script` — reshaping the result set after querying** (runs as JS):
```javascript
function reshapeData(data) {
  const results = []
  data.forEach((obj) => {
    results.push({
      id: obj.id,
      status: obj.status,
      created_at: obj.created_at,
      action: obj.action.toUpperCase(),
      email: obj.user,
    });
  });
  return results;
}
reshapeData(data);
```

**`encoded` — join/filter query string.** Encoded queries let you join tables and filter/sort/paginate inline (`queryType`, `joinType`, `tableReference`, `targetColumn`, `localColumn`, `groupedBy`, `orderBy`, `orderSymbol`, `limitBy`, `offsetBy`, condition blocks joined with `*AND*`/`&&`). Example:
```
queryType=join^tableReference=users^joinType=left^targetColumn=todos.user_id^localColumn=users.id^groupedBy=todos.status_id$todos.id$users.updated_at$users.id$users.email$todos.action$users$todos.priority^[%users.id=todos.user_id*AND*%users.name=admin]*AND*&&queryType=join^joinType=inner^tableReference=status^orderBy=todos.inserted_at^orderSymbol=ASC^limitBy=2500^offsetBy=0^targetColumn=status.id^localColumn=todos.status_id^groupedBy=status$status.id$todos.inserted_at^%status.enum>=0
```

**Full example request (read, with schema + script + encoded combined):**
```json
{
  "type": "data",
  "action": "read",
  "body": {
    "id": "0123123-123123-123123-123123",
    "schema": [
      { "name": "id", "field": "todos.id" },
      { "name": "action", "field": "todos.action" },
      { "name": "priority", "field": "todos.priority" },
      { "name": "status", "field": "status" },
      { "name": "user", "field": "users.email" },
      { "name": "created_at", "field": "todos.inserted_at" }
    ],
    "script": "function reshapeData(data) { ... } reshapeData(data);",
    "encoded": "queryType=join^tableReference=users^joinType=left^..."
  }
}
```

Response:
```json
{
  "data": [
    { "id": "...", "action": "TODO 1", "priority": 1, "status": "TODO", "user": "admin@api2.dev", "created_at": "2019-01-01T00:00:00Z" },
    { "id": "...", "action": "TODO 2", "priority": 2, "status": "TODO", "user": "admin@api2.dev", "created_at": "2019-01-01T00:00:00Z" }
  ]
}
```

### **`GET /api/v1/data/{id}`**

Same capabilities as the `read` action above, exposed as query params instead of a JSON body:

```bash
curl -G "http://localhost:4000/api/v1/data/<table id>" \
  -H "authorization: Bearer <token>" \
  --data-urlencode "page=1" \
  --data-urlencode "page_size=10" \
  --data-urlencode "schema=[{\"name\":\"id\",\"field\":\"todos.id\"}]" \
  --data-urlencode "encoded=queryType=join^..." \
  --data-urlencode "script=function reshapeData(data){...} reshapeData(data);"
```

### **`PUT` / `DELETE /api/v1/data/{id}`**

Update/delete a single record by `id`. Same general shape as the `update`/`delete` actions on `POST /api/v1/data`.

### **Notes**

- `data` operates on **records**, not table definitions — use [[structure]] to create/alter the tables themselves first.
- `encoded` is only available for `read`, `update`, and `delete` — not `create`.
- Prefer `dynamic_request` in the MCP server (see [[mcp]]) for simple single-table CRUD without hand-building an encoded query.

---
See also: [[General]], [[structure]], [[view]] (views let you save a reusable `encoded` query + `schema` under a name), [[search]].
