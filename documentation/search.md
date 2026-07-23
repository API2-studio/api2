## **API2 — `search` Table**

The `search` base endpoint provides full-text and structured search across tables, documents, and records using a Lucene-style JSON query.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/search` | Search tables, documents, and records |

### **Query Parameter**

| Parameter | Required | Description |
|---|---|---|
| `query` | yes | A JSON object containing the Lucene-style query |

The query supports boolean logic (`bool`) with `must`, `should`, and `must_not` clauses, and operators like `term`, `match`, and others.

### **Example — Match Either Field**

Search for records where `table_name` or `name` equals `"users"`:

```json
{
  "query": {
    "bool": {
      "should": [
        { "term": { "table_name": "users" } },
        { "term": { "name": "users" } }
      ]
    }
  }
}
```

- `bool` combines multiple conditions.
- `should` — any matching condition returns the document (logical OR).
- Each `term` clause requires an exact match on that field.

### **Example Request**

```bash
curl -X GET "http://localhost:4000/api/v1/search" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "query": {
      "bool": {
        "should": [
          { "term": { "table_name": "users" } },
          { "term": { "name": "users" } }
        ]
      }
    }
  }'
```

### **Responses**

`200` (Search endpoint request), `403` (Not found error).

### **Notes**

- Use `must` instead of `should` when *all* conditions must match (logical AND).
- Use `must_not` to exclude documents matching a condition.
- For structured, table-scoped filtering/joining instead of full-text search, use [[data]]'s `encoded` query parameter or a saved [[view]] instead.

---
See also: [[General]], [[data]], [[view]], [[structure]].
