## **API2 — `jobs`**

`jobs` let you schedule recurring background tasks (cron jobs) — e.g. periodic cleanup, scheduled reports, or triggering a [[workflows]] run on a timer — without needing an external scheduler.

> **Note:** The underlying dynamic table is `job_schedules`, reachable in the OpenAPI schema at `/api/v1/base/job_schedules` — but that raw path, and `/api/v1/job_schedules`, are both **blocked by the MCP allowlist**. Use `/api/v1/jobs` (verified live — returns `401 unauthenticated` rather than an allowlist error) instead.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/jobs` | List all scheduled jobs |
| POST | `/api/v1/jobs` | Create a scheduled job |
| GET | `/api/v1/jobs/{id}` | Get a single scheduled job |
| PUT | `/api/v1/jobs/{id}` | Update a scheduled job |
| DELETE | `/api/v1/jobs/{id}` | Delete a scheduled job |

### **Schema**

| Field | Type | Description |
|---|---|---|
| `id` | uuid | Job id |
| `type` | string | The kind of job to run |
| `action` | string | The specific action/handler to invoke |
| `body` | object | Payload/parameters passed to the job when it runs |
| `cron` | string | Cron expression controlling when the job runs |
| `timezone` | string | Timezone the cron expression is evaluated in |
| `enabled` | boolean | Whether the schedule is currently active |
| `next_run_at` | datetime, nullable | When the job is next due to run |
| `user_id` | uuid, nullable | The user the job runs as / was created by |
| `acl` | object | Access control |
| `inserted_at` / `updated_at` | datetime | Timestamps |
| `archived_at` / `deleted_at` | datetime, nullable | Soft-delete/archive markers |

### **List Scheduled Jobs — `GET /api/v1/jobs`**

**Query params:** `limit`, `offset`, `page`, `page_size`, `sort_field`, `sort_direction`.

```bash
curl -G "http://localhost:4000/api/v1/jobs" \
  --data-urlencode "page=1" --data-urlencode "page_size=10" \
  -H "authorization: Bearer <token>"
```

### **Create a Scheduled Job — `POST /api/v1/jobs`**

```json
{
  "type": "workflow_trigger",
  "action": "run_workflow",
  "body": { "workflow_id": "6ce579b1-c6f1-46da-896e-bbab9d422a32" },
  "cron": "0 9 * * MON",
  "timezone": "Europe/London",
  "enabled": true
}
```

This example runs every Monday at 9am London time, triggering a [[workflows]] run.

### **Get / Update / Delete a Scheduled Job**

```
GET    /api/v1/jobs/{id}
PUT    /api/v1/jobs/{id}   (same body shape as create; e.g. flip `enabled: false` to pause)
DELETE /api/v1/jobs/{id}
```

### **Responses**

`200` on success. `401` if unauthenticated (verified directly against the live server).

### **Notes**

- Toggle `enabled: false` via `PUT` to pause a job without deleting its configuration.
- `cron` follows standard 5-field cron syntax (`minute hour day-of-month month day-of-week`); `timezone` avoids surprises around daylight saving changes.
- `type` + `action` + `body` determine what actually happens when the job fires — this is where you wire the schedule up to a [[workflows]] trigger, a [[webhooks]] call, or another piece of business logic.

---
See also: [[General]], [[workflows]], [[webhooks]], [[endpoints]], [[data]].