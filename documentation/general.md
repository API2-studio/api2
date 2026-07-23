## **API2 — General Overview**

**API2** is a headless API builder that lets you create, manage, and deploy REST endpoints without writing code. It ships as a single binary executable with an admin interface, turning schema designs into production-ready APIs.

### **What is API2?**

A monolithic application (built on Elixir/Phoenix) that provides:

- **Dynamic REST endpoint creation** — GET, POST, PUT, PATCH, DELETE endpoints through the admin interface
- **Visual database schema builder** — drag-and-drop data structure design
- **Automatic API generation** — schemas become instant REST APIs
- **Built-in authentication & authorization** — role-based access control out of the box
- **Real-time API documentation** — auto-generated OpenAPI specs
- **Zero deployment complexity** — single binary, just run and go

### **Core Features**

- **Instant API Creation** — configure endpoints through the web interface, no coding required, full CRUD support for relational structures
- **Visual Database Designer** — UML-like schema design, relationship support (one-to-many, many-to-many), built-in field types/validation, real-time migration
- **Enterprise-Ready Security** — JWT-based authentication, granular role-based permissions, field-level access controls, API key management
- **Advanced Query Capabilities** — complex JOIN operations, filtering/sorting/pagination, full-text search integration, custom query building
- **Production Ready** — horizontal scaling, WebSocket support, comprehensive audit logging

### **How It Works**

1. **Install** — download the single binary executable
2. **Configure** — access the admin interface to set up your database
3. **Design** — use the visual schema builder to create data structures
4. **Deploy** — REST APIs are automatically generated and available
5. **Integrate** — use the auto-generated documentation to integrate with your applications

### **Use Cases**

- Rapid prototyping — working APIs in minutes
- Backend-as-a-Service for mobile/web applications
- Exposing legacy databases as modern REST APIs
- Lightweight microservices
- Internal tools and admin dashboards

### **API Structure**

Dynamically created table endpoints follow RESTful conventions:

```
GET    /api/v1/dynamic/{table_name}       # List all records
GET    /api/v1/dynamic/{table_name}/{id}  # Get specific record
POST   /api/v1/dynamic/{table_name}       # Create new record
PUT    /api/v1/dynamic/{table_name}/{id}  # Update entire record
PATCH  /api/v1/dynamic/{table_name}/{id}  # Partial update
DELETE /api/v1/dynamic/{table_name}/{id}  # Delete record
```

### **API Surface (as of current build)**

**Base API** — 19 management endpoints across: `audit`, `authentication` (identity callback), `data`, `endpoints`, `files`, `groups`, `indexes`, `roles`, `search`, `structure`, `users`, `view`.

**Dynamic API** — 130 endpoints across 26 tables, covering CRUD for: `workflow_states`, `events`, `event_definitions`, `job_schedules`, `group_roles`, `records`, `webhooks`, `user_groups`, `configs`, `documents`, `roles`, `views`, `email_templates`, `triggers`, `groups`, `endpoints`, `channels`, `tasks`, `files`, `tables`, `users`, `workflows`, `policies`, `request_logs`, `clients`, `user_roles`.

**Route groups:** data · structure · views · authentication · users · roles · indexes · docs · audit · jobs · dashboards · helpers · access_controls · import · logs · search · files · endpoints · workflows · events · webhooks · channels · ws · groups · clients · sdk · dynamic

### **Management API**

The core management endpoints let you configure your API structure programmatically.

**Structure Management** — create and manage database schemas.

<details>
<summary>Create Table — Basic Example</summary>

```json
{
  "name": "products",
  "parent": "base",
  "schema": [
    { "name": "name", "type": "varchar", "required": true },
    { "name": "price", "type": "decimal", "required": true },
    { "name": "description", "type": "text" }
  ]
}
```
</details>

<details>
<summary>Create Table with Relations</summary>

```json
{
  "name": "orders",
  "parent": "base",
  "schema": [
    { "name": "total_amount", "type": "decimal", "required": true },
    { "name": "customer_id", "type": "uuid", "foreign_key": true, "references_table": "customers", "references_column": "id" }
  ],
  "relations": [
    { "relation_type": "belongs_to", "table": "customers", "foreign_key": "customer_id" }
  ]
}
```
</details>

**Endpoint Management** — create custom endpoints with specific query logic and response formatting.

<details>
<summary>Custom GET Endpoint</summary>

```json
{
  "name": "Get Active Products",
  "url": "/api/v1/products/active",
  "method": "GET",
  "source_table": "products",
  "query": {
    "where": { "active": true },
    "order_by": "created_at desc"
  },
  "response_template": {
    "fields": ["id", "name", "price", "created_at"]
  }
}
```
</details>

**User & Role Management** — configure authentication and authorization.

**File Management** — file uploads and attachments with automatic CDN integration.

### **Authentication**

API2 uses bearer-token (JWT) authentication (`Authorization: Bearer <token>`). Obtain a token via the login endpoint:

```
POST /api/v1/authentication/identity/callback
```

### **Getting Started**

1. Download the API2 binary for your platform
2. Run `./api2 start` to launch the server
3. Visit `http://localhost:4000/admin` to access the management interface
4. Create your first table schema
5. Start making API calls to your new endpoints

### **Support & Documentation**

- **Admin Interface** — complete visual management at `/`
- **API Documentation** — auto-generated docs at `/docs`
- **Health Check** — status monitoring at `/health`
- **OpenAPI Spec** — machine-readable spec at `/api/openapi`
- **Demo instance** — [api2.dev](http://api2.dev), docs at [api2.dev/docs](http://api2.dev/docs), Swagger UI at [api2.dev/swaggerui](http://api2.dev/swaggerui), live structure JSON at [api2.dev/structure](http://api2.dev/structure)

---

See also: [[Introduction]], [[API2 - Dynamic Data Queries]], [[Encoded queries explained]], and the `Functions/` folder for per-action (Create/Read/Update/Delete) documentation.
