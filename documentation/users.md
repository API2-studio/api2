## **API2 — `users` Table**

The `users` base table stores every account that can authenticate against your API2 instance. It's one of the built-in tables every API2 install ships with.

### **Endpoints**

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/users` | List all users |
| POST | `/api/v1/users` | Create a user |
| GET | `/api/v1/users/{id}` | Get a single user |
| PUT | `/api/v1/users/{id}` | Update a user |
| DELETE | `/api/v1/users/{id}` | Delete a user |

All requests require `Authorization: Bearer <token>` (obtained from [[authentication]]).

### **List Users — `GET /api/v1/users`**

```json
{
  "users": [
    {
      "id": "0123123-123123-123123-123123",
      "email": "admin@api2.dev",
      "name": "admin",
      "inserted_at": "2020-01-01T00:00:00Z",
      "updated_at": "2020-01-01T00:00:00Z"
    }
  ]
}
```

### **Create User — `POST /api/v1/users`**

```json
{
  "user": {
    "name": "test_example",
    "email": "test@api2.dev",
    "password": "admin123456",
    "password_confirmation": "admin123456",
    "user_roles": [
      { "role_id": "5ceac1eb-0740-472d-98f4-5c022be6496e" }
    ]
  }
}
```

Response:

```json
{
  "user": {
    "id": "5ceac1eb-0740-472d-98f4-5c022be6496e",
    "name": "test_example",
    "email": "test@api2.dev",
    "inserted_at": "2020-01-01T00:00:00Z",
    "updated_at": "2020-01-01T00:00:00Z"
  }
}
```

Attach a role at creation time via `user_roles: [{ "role_id": "<role id>" }]` — see [[roles]] for how roles/permissions are structured.

### **Get / Update / Delete a User**

```
GET    /api/v1/users/{id}
PUT    /api/v1/users/{id}
DELETE /api/v1/users/{id}
```

`PUT` accepts the same body shape as create (`email`, `password`, `password_confirmation`). All three return the same `{ "user": { ... } }` shape.

### **Errors**

```json
{
  "errors": [
    { "message": "Email has already been taken", "field": "email" }
  ]
}
```

`403` is returned as a `Not found error` for any users request that fails authorization/lookup.

### **Notes**

- `email` is unique — creating a duplicate returns a `422`/`403` style error with `"Email has already been taken"`.
- Passwords require both `password` and `password_confirmation` to match.
- To grant permissions to a new user, either attach `user_roles` at creation or manage roles separately via [[roles]] / [[groups]].

---
See also: [[General]], [[roles]], [[groups]], [[authentication]], [[audit]] (user changes are tracked there).
