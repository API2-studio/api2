# API2 Example Runtime Stack

This repository is for running API2 as an example environment using `docker-compose`.

## Configure Image Version

Set the image you want to run:

```bash
export API_IMAGE=api2studio/canopus-api:1.0.1
```

If `API_IMAGE` is not set, `docker-compose.yml` defaults to:

- `api2studio/canopus-api:1.0.1`

## Required Environment Variables

Create or update `.env` with your runtime values.

Update these values before running in your environment:

- `API_IMAGE` (optional override if not using default image tag)
- `COMPOSE_PROJECT_NAME`
- `GUARDIAN_SECRET_KEY`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`
- `POSTGRES_HOST` (default: `database`)
- `POSTGRES_PORT` (default: `5432`)
- `GOOGLE_CLIENT_EMAIL`
- `GOOGLE_PROJECT_ID`
- `GOOGLE_BUCKET_NAME`
- `GCP_PROJECT_ID`
- `GCP_BUCKET`
- `GCP_SCOPE` (only if your service account scope differs)
- `GRAFANA_API_KEY`
- `GRAFANA_USER`
- `GRAFANA_PASSWORD`
- `ELASTIC_USER`
- `ELASTIC_PASS`
- `ELASTIC_HOST` (default: `http://elasticsearch:9200`)
- `KAFKA_BROKER_HOST` (default: `kafka`)
- `KAFKA_BROKER_PORT` (default: `9092`)
- `KAFKA_BROKER_URL` (default: `kafka:9092`)
- `ADMIN_NAME`
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`
- `CLOAK_KEY` (default path: `./secrets/cloak_key`)

Any values currently checked into `.env` should be treated as placeholders and rotated for real environments.

## Required `secrets/` Folder

Create a local folder named `secrets` in the project root:

```bash
mkdir -p secrets
```

Add these files inside `secrets/`:

1. `application_default_credentials.json`
2. `cloak_key`

Expected structure:

```text
secrets/
  application_default_credentials.json
  cloak_key
```

These are mounted into the API container as:

- `/app/secrets/application_default_credentials.json`
- `/app/secrets/cloak_key`

And referenced by environment values:

- `GCP_CREDENTIALS=./secrets/application_default_credentials.json` (in `.env`)
- `CLOAK_KEY=./secrets/cloak_key` (in `.env`)

NOTE: The `cloak_key` file should contain a random string used for encryption. You can generate one with:

```bash
openssl rand -base64 32 > secrets/cloak_key
```

NOTE: The `application_default_credentials.json` file should contain your GCP service account credentials in JSON format.

NOTE: For production environments, consider using a secure secrets management solution instead of local files.


## Start

```bash
docker compose pull api
docker compose up -d
```

View logs:

```bash
docker compose logs -f api
```

## Update or Rollback

Deploy a newer release:

```bash
export API_IMAGE=api2studio/canopus-api:1.0.1
docker compose pull
docker compose up -d
```

Rollback by setting `API_IMAGE` back to a previous tag and running the same commands.

## Stop

```bash
docker compose down
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
