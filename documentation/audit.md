## **API2 — `audit` Table**

The `audit` base table automatically records every change made to your data — who changed what, and the before/after values — for compliance and debugging.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/audit` | List all audit log entries |

Audit logs are read-only — entries are created automatically by API2 whenever a record is created, updated, or deleted.

### **Available Filters**

| Param | Description |
|---|---|
| `page_number` | Page number in pagination |
| `page_size` | Records per page |
| `record_id` | Filter by the specific record that changed |
| `table_id` | Filter by which table the change happened on |
| `created_by` | Filter by who made the change |
| `updated_by` | Filter by who last updated the record |

### **Example Request**

```bash
curl -X GET "http://localhost:4000/api/v1/audit" \
  -H "accept: application/json" \
  --data-urlencode "page_number=1" \
  --data-urlencode "page_size=10" \
  -H "authorization: Bearer <token>"
```

Filter to a specific record:
```bash
curl -G "http://localhost:4000/api/v1/audit" \
  --data-urlencode "page_number=1" --data-urlencode "page_size=10" \
  --data-urlencode "record_id=<record id>" \
  -H "authorization: Bearer <token>"
```

### **Example Response**

```json
{
  "data": [
    {
      "id": "c5c7935f-1b3a-45b8-b497-1deeec8a415e",
      "data_type": "record",
      "table_id": "163a5a64-e3c1-422d-8683-2e69a79f13d9",
      "table_name": "users",
      "record_id": "6ce579b1-c6f1-46da-896e-bbab9d422a32",
      "created_by": "6ce579b1-c6f1-46da-896e-bbab9d422a32",
      "updated_by": "6ce579b1-c6f1-46da-896e-bbab9d422a32",
      "old_value": { "email": "admin@api2.dev", "name": "admin", "...": "..." },
      "new_value": { "email": "admin@api2.dev", "name": "admin", "...": "..." },
      "inserted_at": "2024-04-27T05:07:48Z",
      "updated_at": "2024-04-27T05:07:48Z"
    }
  ],
  "page_number": 1,
  "page_size": 150,
  "total_entries": 1,
  "total_pages": 1
}
```

### **Responses**

`200`, `400` (Bad Request), `401` (Unauthorized), `403` (Forbidden), `404` (Not Found), `422` (Unprocessable Entity), `500` (Internal Server Error).

### **Notes**

- `old_value` / `new_value` give a full snapshot of the record before/after the change — useful for rollback logic or compliance review.
- Combine `table_id` + `record_id` filters to get the complete history of one specific record.

---
See also: [[General]], [[users]], [[data]], [[structure]].
