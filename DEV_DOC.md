# Developer Documentation
This document describes how a developer can manage, build, and interact with the Inception infrastructure.

## Set Up the Environment from Scratch
Because public credentials are strictly forbidden, you must set up your local configuration and secrets manually before building the project. 

1. **Clone the Repository:** Clone the Git repository into your workspace.
2. **Local Secrets Stash:** Keep a secure folder outside of the repository (e.g., `~/safe_secrets/`) containing your `secrets/` directory and `srcs/.env` file.
3. **Copy Configuration:** Before running the build, copy your secure files into the cloned repository:
   ```bash
   cp -r ~/safe_secrets/secrets ./
   cp ~/safe_secrets/.env ./srcs/
4. **Host Resolution:** Ensure that 127.0.0.1 hkasamat.42.fr is added to your /etc/hosts file.

## Build and Launch the Project
The entire application is managed via the Makefile located at the root.

* `make` or `make up`: Automatically creates the necessary host data directories (`/home/hkasamat/data/mariadb` and `/home/hkasamat/data/wordpress`), builds the Docker images, and starts the containers in detached mode (-d).
* `make down`: Stops and removes the containers using docker compose down.
* `make clean`: Stops the containers and removes the associated Docker volumes (-v).
* make fclean: Performs a clean, forcefully deletes all contents inside the host data directories (`sudo rm -rf`), and runs `docker system prune -af` to completely clear all unused images, containers, and networks.
* `make re`: Completely wipes the environment (`fclean`) and rebuilds everything from scratch (`all`).

## Manage Containers and Volumes
While the Makefile handles the heavy lifting, you can use standard Docker commands for finer control:

* **View Logs:** `docker logs <container_name>` (e.g., `nginx`, `wordpress`, `mariadb`) to troubleshoot issues.
* **Access a Container:** `docker exec -it <container_name> bash` (or `sh`) to open an interactive shell inside a running container.
* **List Volumes:** `docker volume ls` to view the active storage volumes.

## Data Storage and Persistence
The project uses Docker named volumes mapped to specific host directories for persistent storage, ensuring data survives container restarts and removals. The `Makefile` automatically ensures these directories exist on the host machine during the `up` process.

* **Database:** The MariaDB data is stored persistently in `/home/hkasamat/data/mariadb`.
* **Website Files:** The WordPress files are stored persistently in `/home/hkasamat/data/wordpress`.