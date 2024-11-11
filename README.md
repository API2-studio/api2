# Alpha Release of API2 
This is a development release of api2 it is not inteneded for production or any real world projects at this stage it is added here purly so it can be tested. However, keep checking back as we are about 8 months from realsing the MVP to the open market. 

---
## Downloading a Release

Choose the appropriate release for your environment from the "Releases" section of this repository. For example:

- For macOS with an Intel chip, choose `mac_intel`.
- For macOS with an M1/M2 chip, choose `mac_m1` or `mac_m2`.
- For deployment on Linux distributions (e.g., Ubuntu, Debian, Arch) within a Docker container or directly, select the corresponding `linux_<distro>` option.

## Unzipping the Release

### Unix, macOS, or Linux

Open a terminal and navigate to the directory where you want to extract the release. Use the following command to unzip the release package:

```bash
tar -xzvf api2-release-v1.0.0_<distribution>.tar.gz -C /path/to/destination
```

Replace `<distribution>` with the specific build for your system (e.g., `mac_intel`, `linux_ubuntu`). Use the actual path where you want to extract the files in place of `/path/to/destination`.

## Setting Environment Variables

Before running migrations or starting the application, set the required environment variables in the context where the binary will run. This might be your terminal session or a configuration file for your deployment environment.

## Required variables
```bash
COMPOSE_PROJECT_NAME=canopus
GUARDIAN_SECRET_KEY=some_key908128390123089
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=database
POSTGRES_PORT=5432
POSTGRES_DB=canopus
ADMIN_NAME=admin
ADMIN_EMAIL=admin@api2.dev
ADMIN_PASSWORD=admin123456
DBDOCS_TOKEN=some_tokenhpE55YEGvafsnNwN7ccA5LPYt21q3yoy9pCjtoDaPWg
OTP_APP_ENV_VAR_NAME=dynamic
LOG_RETENTION_DAYS=90
DATA_RETENTION_ID_DAYS=3000
GCP_CREDENTIALS=./secrets/application_default_credentials.json
GOOGLE_CLIENT_EMAIL=api2-client@api2-mvp.iam.gserviceaccount.com
ADMIN_AVATAR_PATH="./priv/static/Icon 64.jpeg"
GOOGLE_PROJECT_ID=api2-mvp
GOOGLE_BUCKET_NAME=api2-mvp
GOOGLE_BUCKET_URL=https://storage.googleapis.com/api2-mvp
GOOGLE_BUCKET_PATH=api2-mvp
GRAFANA_API_KEY=eyJrIjoiZm1t #This is set in the grafana service in docker compose
GRAFANA_ORG_ID=1
GRAFANA_DASHBOARD_ID=1
GRAFANA_DASHBOARD_UID=1
GRAFANA_HOST=http://grafana:3000 #This is set in the grafana service in docker compose
GRAFANA_PORT=3000 #This is set in the grafana service in docker compose
GRAFANA_USER=admin
GRAFANA_PASSWORD=admin
GCP_PROJECT_ID=api2-mvp
GCP_BUCKET=api2-mvp
GCP_BUCKET_URL=https://storage.googleapis.com/api2-mvp
GCP_BUCKET_PATH=api2-mvp
GCP_SCOPE=https://www.googleapis.com/auth/devstorage.full_control
GCP_STORAGE_DIR=/uploads
VUE_APP_API_BASE_URL=http://localhost:4000/api/v1
VUE_APP_PROXY_BASE_URL=http://localhost:4000
ELASTIC_USER=elastic
ELASTIC_PASS=--i1o-tRLIVf0-KqtFW-
ELASTIC_HOST=http://elasticsearch:9200
ACCESS_TOKEN_TTL_IN_MINUTES=2999
REFRESH_TOKEN_TTL_IN_MINUTES=2999
USER_AUTH_TTL_IN_DAYS=7
GRAFANA_UPLOAD_DASHBOARDS_ON_START=true
GUARDIAN_TTL_IN_MINUTES=2999
GUARDIAN_REFRESH_TTL_IN_MINUTES=2999
ACCESS_TOKEN_TTL_IN_DAYS=7
REFRESH_TOKEN_TTL_IN_DAYS=7
```

Replace placeholder values like `yourpassword` and `strongpassword` with secure values appropriate for your setup.

## Build and Run the Application

After setting the required environment variables, you can build and run the application. Use the following commands to build and run the application:

```bash
docker compose up --build
```

This command will build the application and start the services defined in the `docker-compose.yml` file. The application will be available at `http://localhost:4000`. As Nginx is used as a reverse proxy, the application will be served over HTTP on localhost.

## Accessing the Application

You can access the application by navigating to `http://localhost:4000` in your web browser. The application will be available at this address.

## Stopping the Application

To stop the application, use the following command:

```bash
docker compose down
```

This command will stop and remove the containers defined in the `docker-compose.yml` file.

## Updating the Application

To update the application, download the latest release from the "Releases" section of this repository and follow the steps outlined in the "Downloading a Release" section. After downloading the release, follow the steps in the "Build and Run the Application" section to build and run the updated version of the application.

## Troubleshooting

If you encounter any issues while building or running the application, please refer to the troubleshooting section in the README file of the repository. If the issue persists, feel free to open an issue in the repository, and we will do our best to assist you.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```


