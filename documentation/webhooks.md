## **API2 — `webhooks`**

`webhooks` let you register outbound HTTP calls that fire automatically when a specific event happens in API2 — the standard way to push data out to external systems (Slack, Zapier, your own services, etc.) for integrations.

> **Note:** The underlying dynamic table is reachable in the OpenAPI schema at `/api/v1/base/webhooks`, but that raw path is **blocked by the MCP allowlist**. Use `/api/v1/webhooks` (verified live — returns `401 unauthenticated` rather than an allowlist error) instead.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/webhooks` | List all webhooks |
| POST | `/api/v1/webhooks` | Create a webhook |
| GET | `/api/v1/webhooks/{id}` | Get a single webhook |
| PUT | `/api/v1/webhooks/{id}` | Update a webhook |
| DELETE | `/api/v1/webhooks/{id}` | Delete a webhook |

### **Schema**

| Field | Type | Description |
|---|---|---|
| `id` | uuid | Webhook id |
| `name` | string | Webhook name |
| `target_url` | string | The URL to POST the payload to when triggered |
| `event_slug` | string | Identifier for which event triggers this webhook |
| `condition` | object/string | Optional condition that must be true for the webhook to fire |
| `headers` | object | Custom HTTP headers to send with the outbound request |
| `template` | object/string | Payload template — shapes the body sent to `target_url` |
| `acl` | object | Access control |
| `inserted_at` / `updated_at` | datetime | Timestamps |
| `archived_at` / `deleted_at` | datetime, nullable | Soft-delete/archive markers |

### **List Webhooks — `GET /api/v1/webhooks`**

**Query params:** `limit`, `offset`, `page`, `page_size`, `sort_field`, `sort_direction`.

```bash
curl -G "http://localhost:4000/api/v1/webhooks" \
  --data-urlencode "page=1" --data-urlencode "page_size=10" \
  -H "authorization: Bearer <token>"
```

### **Create a Webhook — `POST /api/v1/webhooks`**

```json
{
  "name": "Notify Slack on new order",
  "target_url": "https://hooks.slack.com/services/T000/B000/XXXX",
  "event_slug": "orders.created",
  "condition": { "field": "total", "operator": ">", "value": 100 },
  "headers": { "Content-Type": "application/json" },
  "template": {
    "text": "New order placed: {{order.id}} — ${{order.total}}"
  }
}
```

### **Get / Update / Delete a Webhook**

```
GET    /api/v1/webhooks/{id}
PUT    /api/v1/webhooks/{id}   (same body shape as create)
DELETE /api/v1/webhooks/{id}
```

### **Responses**

`200` on success. `401` if unauthenticated (verified directly against the live server).

### **Notes**

- `event_slug` ties the webhook to a specific event type in your instance.
- `condition` lets you fire the same event selectively (e.g. only notify on orders over a certain amount).
- `template` supports interpolation of the triggering record's fields.
- Pair webhooks with [[workflows]] (fire from a workflow task's `action`) or [[jobs]] (periodically check something and fire a webhook) for more advanced automation.

---
See also: [[General]], [[workflows]], [[jobs]], [[endpoints]], [[data]].