## **API2 — `files` Table**

The `files` base table handles file uploads and attachments, with automatic CDN/URL generation for stored files.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/files` | List all files |
| POST | `/api/v1/files` | Upload/create a file |
| GET | `/api/v1/files/{id}` | Get a single file |
| PUT | `/api/v1/files/{id}` | Update a file |
| DELETE | `/api/v1/files/{id}` | Delete a file |

### **Schema**

| Field | Description |
|---|---|
| `id` | File id |
| `name` | File name |
| `type` | MIME type |
| `file` | Stored file reference |
| `file_url` | Publicly accessible URL |
| `inserted_at` / `updated_at` | Timestamps |
| `archived_at` / `deleted_at` | Soft-delete markers, nullable |

### **List Files — `GET /api/v1/files`**

**Filters:** `page_number`, `page_size`, `record_id`, `table_id`, `created_by`, `updated_by`.

```bash
curl -X GET "http://localhost:4000/api/v1/files" \
  --data-urlencode "page_number=1" --data-urlencode "page_size=10" \
  -H "authorization: Bearer <token>"
```

```json
{
  "data": [
    {
      "id": "15132-871239-123789",
      "name": "file.pdf",
      "type": "application/pdf",
      "file": "gcpreference",
      "file_url": "https://s3.amazonaws.com/gcpreference",
      "inserted_at": "2024-04-27T05:07:48Z",
      "updated_at": "2024-04-27T05:07:48Z",
      "archived_at": null,
      "deleted_at": null
    }
  ],
  "pagination": { "page_number": 1, "page_size": 10, "total_pages": 5, "total_entries": 50 }
}
```

### **Create/Upload a File — `POST /api/v1/files`**

```bash
curl -X POST "http://localhost:4000/api/v1/files" \ 
  -H "authorization: Bearer <token>" \
  -d '{ "name": "file.pdf", "type": "application/pdf", "file": "gcpreference" }'
```

### **Get / Update / Delete a File**

```
GET    /api/v1/files/{id}
PUT    /api/v1/files/{id}    (accepts name/type/file)
DELETE /api/v1/files/{id}
```

Delete response includes a confirmation message:
```json
{ "file": { "...": "...", "deleted_at": "2024-04-27T05:07:48Z" }, "message": "File deleted successfully" }
```

### **Responses**

`200`, `400` (Bad Request), `401` (Unauthorized), `403` (Forbidden), `404` (Not Found), `422` (Unprocessable Entity), `500` (Internal Server Error).

### **Notes**

- `file_url` is generated automatically once a file is stored — use it directly to serve/download the file.
- Files can be filtered by `table_id` / `record_id`, meaning file attachments can be scoped to a specific record on another table.

---
See also: [[General]], [[data]], [[audit]].
