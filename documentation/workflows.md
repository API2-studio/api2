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

### **`js_script` action**

`js_script` runs an asynchronous JavaScript snippet in the isolated `workflow-js` service. Put the source in `action_data.script`; scripts receive a read-only `context` and the `actions` API. Calls must be awaited and each action receives an object of context fields to add for that call.

```json
{
  "name": "Create then log",
  "action": "js_script",
  "action_data": {
    "script": "await actions.createRecord({ payload: context.payload });\nawait actions.logInfo({ info: { message: 'Record created' } });\nreturn { created: true };"
  }
}
```

The API exposes: `sendEmail`, `generateReport`, `logError`, `logInfo`, record and structure CRUD actions, `createJob`, `createIndex`, `loadDataToVariable`, `request`, `checkPermissions`, `externalApiCall`, `conditionOnly`, `noAction`, and `webhookEvent`. It deliberately does not expose `js_script`, `runWorkflow`, `resetWorkflow`, or `kafkaMessage`.

The script's return value is saved in workflow context as `script_result`. Scripts cannot replace `user_id` or `workflow_id`; each action runs in Elixir using the original, server-held workflow context.

#### Deployment configuration

The API needs `WORKFLOW_JS_RUNNER_URL` (normally `http://workflow-js:3000/execute`), `WORKFLOW_JS_RUNNER_TIMEOUT_MS` (normally `10000`), and `WORKFLOW_JS_RUNNER_SECRET`. The runner needs the same secret, `WORKFLOW_JS_CALLBACK_URL` (normally `http://api:4000/internal/workflow-js/action`), `WORKFLOW_JS_TIMEOUT_MS`, and `PORT`.

The Helm runner is disabled by default. Enable it with a Secret that contains `WORKFLOW_JS_RUNNER_SECRET`:

```yaml
workflowJs:
  enabled: true
  secret:
    existingSecret: workflow-js-production-secret
```

The chart deploys the runner with a read-only filesystem, non-root user, dropped capabilities, runtime-default seccomp, no service-account token, resource limits, and a NetworkPolicy allowing only API traffic plus cluster DNS. The cluster CNI must enforce `NetworkPolicy` for the latter control to be effective.

### **Create a Workflow — `POST /api/v1/workflows`**

```json
{
  "name": "New Employee Onboarding",
  "description": "Provision accounts and send welcome docs for a new hire",
  "repeatable": true,
  "acl": { "roles": ["hr_admin"] },
  "triggers": [
    {
      "event_source": "db",
      "event_type": "insert",
      "table_name": "users"
    }
  ],
  "tasks": [
    {
      "name": "Create accounts",
      "action": "createRecord",
      "action_data": { 
          "name": "{{context.trigger_response.name}}",
          "email": "{{context.trigger_response.email}}",
       },
      "initial": true,
      "next_task": {
        "name": "Send welcome email",
        "action": "send_email",
        "action_data": { "template": "welcome", "to": "{{context.trigger_response.email}}" },
      }
    }
  ]
}
```

### **Create a Workflow (Conditions) — `POST /api/v1/workflows`**

```json
{
  "name": "New Employee Onboarding",
  "description": "Provision accounts and send welcome docs for a new hire",
  "repeatable": true,
  "triggers": [
    {
      "event_source": "db",
      "event_type": "insert",
      "table_name": "users"
    }
  ],
  "tasks": [
    {
      "name": "Create accounts",
      "action": "createRecord",
      "action_data": {
        "action": "create",
        "type": "data",
        "body": {
          "id":"<uuid for table>",
          "schema": [
            {
              "field": "name",
              "value": "{{context.trigger_response.name}}",
            },
            {
              "field": "email",
              "value": "{{context.trigger_response.email}}"
            }
          ]
        },
      },
      "initial": true,
      "next_task": {
        "name": "Send welcome email",
        "action": "sendEmail",
        "action_data": { "template": "welcome", "to": "{{context.trigger_response.email}}" },
        "condition": "context.trigger_response.name != admin",
        "on_true": {
          "name": "log info",
          "action": "logInfo",
          "action_data": {
            "info": {
              "message": "Onboarding Success!"
            }
          }
        },
        "on_false" {
          "name": "log error",
          "action": "LogError",
          "action_data": {
            "error": {
              "message": "Admin is already onboarded!"
            }
          }
        }
      }
    }
  ]
}
```

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