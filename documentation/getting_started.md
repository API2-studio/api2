## Getting Started

Welcome to the Getting Started guide! This document will help you set up your environment and get started with our application. Follow the steps below to ensure a smooth installation and configuration process.

### Prerequisites
Before you begin, make sure you have the following prerequisites installed on your system:

All images are provided on Docker Hub and can be pulled using the `docker pull` command. 
Docker Hub: https://hub.docker.com/r/api2studio/canopus-api 

- Docker: Make sure you have Docker installed on your machine. You can download it from [Docker's official website](https://www.docker.com/get-started).
- Docker Compose: Ensure you have Docker Compose installed. You can find installation instructions on the [Docker Compose documentation](https://docs.docker.com/compose/install/).
- Node.js: Install Node.js (version 14 or higher) from [Node.js official website](https://nodejs.org/).
- npm: Ensure you have npm (Node Package Manager) installed. It usually comes with Node.js, but you can verify by running `npm -v` in your terminal.
- Git: Install Git from [Git's official website](https://git-scm.com/).
- A code editor of your choice (e.g., Visual Studio Code, Sublime Text, etc.).
- A terminal or command prompt to run commands.

### Installation Steps
1. **Clone the Repository**: Start by cloning the repository to your local machine using Git:
   ```bash
    git clone git@github.com:API2-studio/api2.git
    ```
2. **Navigate to the Project Directory**: Change into the project directory:
   ```bash
    cd api2
    ```
3. **Configure the Environment**: Set up the necessary environment variables and configuration files.
4. **Configure Secrets**: Set up the necessary secrets for your application.
    a. GCP application.json 
    b. Cloak Key cloak_key  
5. **Set Api Image**: Set the image you want to run:
    ```bash
    export API_IMAGE=api2studio/canopus-api:1.1.5
    ```
6. **Docker Compose**: Run the up command
    ```bash
    docker compose up 
    ```
7. **Helm Deployment**: 
    Kubernetes cluster access (kubectl configured)
    ```bash
    helm upgrade --install api2 ./helm/api2 -n api2 --create-namespace
    ```


