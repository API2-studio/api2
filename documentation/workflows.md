## **API2 — `workflows`**

`workflows` let you define a repeatable business process as a graph of tasks, fired by one or more triggers. Unlike most base tables, workflows are managed through a dedicated composite endpoint rather than the generic dynamic-table CRUD — creating a workflow lets you define its `triggers` and `tasks` as **nested arrays in the same request**, rather than creating each as a separate record.

> **Note:** The underlying dynamic tables this is built on (`workflows`, `workflow_states`, `triggers`, `tasks`) exist in the OpenAPI schema at paths like `/api/v1/base/workflows`, but those raw paths are **blocked by the MCP allowlist** and are not the intended interface. Always create/manage workflows through `/api/v1/workflows` below.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/workflows` | List all workflows |
| POST | `/api/v1/workflows` | Create a workflow, with nested `triggers` and `tasks` |
| GET | `/api/v1/workflows/{id}` | Get a single workflow |
| PUT | `/api/v1/workflows/{id}` | Update a workflow |
| DELETE | `/api/v1/workflows/{id}` | Delete a workflow |

### **Workflow Fields**

| Field | Type | Description |
|---|---|---|
| `id` | uuid | Workflow id |
| `name` | string | Workflow name |
| `description` | string, nullable | Human-readable description |
| `repeatable` | boolean, nullable | Whether this workflow can be re-triggered multiple times |
| `triggers` | array | Nested trigger definitions (see below) |
| `tasks` | array | Nested task/step definitions (see below) |
| `acl` | object | Access control |
| `inserted_at` / `updated_at` | datetime | Timestamps |
| `archived_at` / `deleted_at` | datetime, nullable | Soft-delete/archive markers |

### **Nested `triggers[]`**

A trigger fires the workflow when a matching event occurs on a table.

| Field | Description |
|---|---|
| `event_source` | Where the event originates from |
| `event_type` | The kind of event (e.g. `created`, `updated`, `deleted`) |
| `table_name` | The table being watched |

### **Nested `tasks[]`**

Tasks form a linked graph of steps — each task points to what runs next, with optional branching.

| Field | Description |
|---|---|
| `name` | Task name |
| `action` | The action/handler this task performs |
| `action_data` | Parameters passed to the action |
| `condition` | Optional condition evaluated for branching |
| `initial` | Marks this as the workflow's starting task |
| `next_task_id` | The task to run next (linear flow) |
| `on_true_id` / `on_false_id` | Branch targets when `condition` is used (conditional flow) |
| `previous_task_id` | The preceding task in the graph |

### **Create a Workflow — `POST /api/v1/workflows`**

```json
{
  "name": "New Employee Onboarding",
  "description": "Provision accounts and send welcome docs for a new hire",
  "repeatable": true,
  "acl": { "roles": ["hr_admin"] },
  "triggers": [
    {
      "event_source": "data",
      "event_type": "created",
      "table_name": "employees"
    }
  ],
  "tasks": [
    {
      "name": "Create accounts",
      "action": "create_user_accounts",
      "action_data": { "systems": ["email", "slack"] },
      "initial": true,
      "next_task_id": "send_welcome_email"
    },
    {
      "name": "Send welcome email",
      "action": "send_email",
      "action_data": { "template": "welcome" },
      "previous_task_id": "create_accounts"
    }
  ]
}
```

> The exact mechanism for linking `next_task_id`/`on_true_id`/`on_false_id`/`previous_task_id` between tasks in the same create request (temporary reference vs. real id) isn't documented in the OpenAPI spec — confirm the expected linking format against a real create call/response before relying on it in production.

### **Get / Update / Delete a Workflow**

```
GET    /api/v1/workflows/{id}
PUT    /api/v1/workflows/{id}   (same nested body shape as create)
DELETE /api/v1/workflows/{id}
```

### **Responses**

`200` on success. `401` if unauthenticated (verified directly against the live server).

### **Notes**

- Don't create `triggers`/`tasks`/`workflow_states` directly — those dynamic tables are not reachable via the MCP allowlist. Manage them entirely through the nested `triggers`/`tasks` arrays on `/api/v1/workflows`.
- `workflow_states` still exists as the underlying execution-tracking table (one row per run/step, with `state`, `started_at`, `completed_at`), but read it through whatever reporting/read path your instance exposes rather than `/api/v1/base/workflow_states` directly.
- Pair with [[webhooks]] (fire a webhook from a task's `action`) and [[jobs]] (schedule a workflow to run on a cron) for end-to-end automation.

---
See also: [[General]], [[webhooks]], [[jobs]], [[endpoints]], [[data]].