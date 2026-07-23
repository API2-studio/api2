## **API2 — `authentication` Table**

The `authentication` base endpoint handles logging in and issuing the bearer token used to authorize every other request in the API.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| POST | `/api/v1/authentication/identity/callback` | Log in and receive a token |

### **Request Body**

| Field | Type | Description |
|---|---|---|
| `email` | string | The user's email |
| `password` | string | The user's password |

```json
{
  "user": {
    "email": "admin@api2.dev",
    "password": "admin123456"
  }
}
```

### **Response Body**

| Field | Type | Description |
|---|---|---|
| `token` | string | Bearer token to use in the `Authorization` header on subsequent requests |
| `user` | object | The authenticated user |
| `user.id` | string | User id |
| `user.email` | string | User email |
| `user.inserted_at` / `user.updated_at` | datetime | Timestamps |
| `permissions` | object | The effective permissions for the logged-in user (merged from their role(s)) |

```json
{
  "user": {
    "id": "12344213-1234-1234-1234-123412341234",
    "email": "admin@api2.dev",
    "inserted_at": "2019-01-01T00:00:00Z",
    "updated_at": "2019-01-01T00:00:00Z"
  },
  "permissions": {
    "auth": ["create", "read", "update", "delete"]
  },
  "token": "eyJhbGciOi..."
}
```

### **Using the Token**

Every other endpoint in the API expects the returned token as a bearer token:
```
Authorization: Bearer <token>
```

### **Demo Credentials**

For local/demo instances, API2 ships a default admin account:
```
email: admin@api2.dev
password: admin123456
```

### **Responses**

`200` (successful login), `403` (Not found error — invalid credentials).

### **Notes**

- Authentication uses a JWT-based bearer scheme (`type: http`, `scheme: bearer`).
- The MCP server's `api2_request` tool handles attaching the token for you — you don't need to call this endpoint manually when working through the MCP (see [[mcp]]).

---
See also: [[General]], [[users]], [[roles]], [[mcp]].
