## **API2 — `indexes` Table**

The `indexes` base table lets you create and manage database indexes on any table's columns for query performance (e.g. enforcing uniqueness or speeding up lookups).

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/indexes` | List all indexes |
| POST | `/api/v1/indexes` | Create an index |
| GET | `/api/v1/indexes/{table_id}` | Get index(es) for a table |
| PUT | `/api/v1/indexes/{table_id}` | Create/update an index on a table |
| DELETE | `/api/v1/indexes/{table_id}` | Delete an index |

### **Schema**

| Field | Type | Description |
|---|---|---|
| `id` | integer/uuid | Index id |
| `index_name` | string | Name of the index |
| `table_name` / `index_table` | string | The table the index is on |
| `fields` | array | Columns covered by the index |
| `unique` | boolean | Whether the index enforces uniqueness |
| `options` | string | Additional index options |
| `inserted_at` / `updated_at` | datetime | Timestamps |

### **List Indexes — `GET /api/v1/indexes`**

```json
{
  "data": [
    {
      "id": 1,
      "index_name": "index_name",
      "index_table": "index_table",
      "index_definition": "index_definition",
      "inserted_at": "2021-01-01T00:00:00",
      "updated_at": "2021-01-01T00:00:00"
    }
  ]
}
```

### **Get Indexes for a Table — `GET /api/v1/indexes/{table_id}`**

| Parameter | In | Required | Description |
|---|---|---|---|
| `table_id` | path | yes | The table to get indexes for |
| `index_name` | query | no | Filter by index name |
| `page` / `page_size` | query | no | Pagination |

### **Create an Index — `POST /api/v1/indexes`**

```json
{
  "action": "create",
  "type": "index",
  "body": {
    "id": "7e7361d5-f1c5-45c2-912e-ac666703882e",
    "index_name": "users_email_index",
    "fields": ["email"],
    "unique": true
  }
}
```

Response:
```json
{ "message": "Index created" }
```

### **Delete an Index — `DELETE /api/v1/indexes/{table_id}`**

```json
{
  "action": "delete",
  "type": "index",
  "body": { "id": "b5c4f840-5927-4b4c-9ad2-d69f9df3fdfa", "index_name": "story_index", "unique": false }
}
```

Response:
```json
{ "message": "Index deleted" }
```

### **Responses**

`200`, `403` (Not found), `404` (Forbidden), `500` (Internal Server Error).

### **Notes**

- `body.id` in create/delete requests refers to the **table id** the index applies to (from [[structure]]), not the index's own id.
- Set `unique: true` to enforce a uniqueness constraint (e.g. for a table's `email` column) rather than just speeding up lookups.

---
See also: [[General]], [[structure]], [[data]].
