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

```bash
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=yourpassword
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_DATABASE=canopus
export ADMIN_NAME=admin
export ADMIN_EMAIL=admin@api2.dev
export ADMIN_PASSWORD=strongpassword
export OTP_APP=dynamic
export LOG_RETENTION_DAYS=90
export DATA_RETENTION_DAYS=3000
```

Replace placeholder values like `yourpassword` and `strongpassword` with secure values appropriate for your setup.

## Running Migrations

Ensure that your database service is running and accessible using the credentials provided in the environment variables. Then, execute the following command to run database migrations:

```bash
./bin/dynamic eval "Dynamic.Release.migrate()"
```

## Initialising the Application

## Starting the Application

Navigate to the root directory of your unzipped release, then start the application:

```bash
cd /path/to/destination/api2-release-v1.0.0_<distribution>
./bin/dynamic start
```

Replace `/path/to/destination` with the actual path where you extracted the release files.


After setting the environment variables and running migrations, initialise the admin role and user in the running container:

```bash
./bin/dynamic rpc "Dynamic.GlobalSetup.run()"
```

---
