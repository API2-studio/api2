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

## Optional OAuth login providers

Password login remains enabled at `POST /api/v1/authentication/identity/callback` and
continues to return the application's Guardian JWT. Google, Microsoft, and Apple login
are opt-in: a provider is registered only when both of its client environment variables
are non-empty.

| Provider | Environment variables | Start URL | Callback URL |
| --- | --- | --- | --- |
| Google | `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET` | `/api/v1/authentication/google` | `/api/v1/authentication/google/callback` |
| Microsoft | `MICROSOFT_OAUTH_CLIENT_ID`, `MICROSOFT_OAUTH_CLIENT_SECRET`, optional `MICROSOFT_OAUTH_TENANT_ID` (defaults to `common`) | `/api/v1/authentication/microsoft` | `/api/v1/authentication/microsoft/callback` |
| Apple | `APPLE_OAUTH_CLIENT_ID`, `APPLE_OAUTH_CLIENT_SECRET` | `/api/v1/authentication/apple` | `/api/v1/authentication/apple/callback` |

Register the exact callback URL with each provider. Apple uses a `POST` callback and
requests the `name email` scopes. Its client secret expires, so deployments must rotate
`APPLE_OAUTH_CLIENT_SECRET` before its configured expiry.

When a provider returns a valid email address that does not match a local user, OAuth
login creates that user and assigns the system-managed `basic` role. Permission sync
creates or updates this non-registerable role with only `auth` read, update, and delete
permissions. Existing users retain their current roles. On success, the response has the
same Guardian JWT, user, and permissions shape as password login, so API bearer-token
authentication is unchanged.
- The MCP server's `api2_request` tool handles attaching the token for you — you don't need to call this endpoint manually when working through the MCP (see [[mcp]]).

---
See also: [[General]], [[users]], [[roles]], [[mcp]].
