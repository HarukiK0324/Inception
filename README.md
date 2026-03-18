*This project has been created as part of the 42 curriculum by hkasamat

## Description
This project aims to broaden knowledge of system administration by using Docker. The goal is to set up a small infrastructure composed of different services running in dedicated containers within a personal virtual machine. The stack includes a secure NGINX web server, a WordPress site with PHP-FPM, and a MariaDB database.

## Instructions
1. Clone this repository to the local virtual machine.
2. Follow the setup steps outlined in `DEV_DOC.md` to safely configure the local `secrets/` files.
3. Run `make` at the root of the directory to build the Docker images and set up the entire application.
4. To access the site, ensure the domain name (`hkasamat.42.fr`) is configured in the `/etc/hosts` file to point to your local IP address.

## Resources
* [Docker Documentation](https://docs.docker.com/)
* [NGINX Documentation](https://nginx.org/en/docs/)
* [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
* [WordPress Developer Resources](https://developer.wordpress.org/)

### AI Usage
*I used AI tools during this project primarily for understanding Docker container networking, structuring my `docker-compose.yml`, and discussing the safest strategies to handle Docker secrets without committing them to my Git repository.*

## Project description
This project utilizes Docker to containerize our infrastructure, avoiding the use of ready-made images from DockerHub (except for the Debian base). I wrote individual Dockerfiles for each service.

### Design Choices & Comparisons

**Virtual Machines vs Docker**
Virtual machines virtualize the physical hardware, running a full guest operating system on top of a hypervisor. Docker, on the other hand, uses OS-level virtualization. Containers share the host system's kernel, making them much more lightweight, faster to start, and less resource-intensive than traditional VMs.

**Secrets vs Environment Variables**
Environment variables are often exposed to the entire system or logged by debugging tools. Docker Secrets are a more secure mechanism for confidential data. They are mounted as read-only files in memory (usually in `/run/secrets/`) only to the containers that explicitly need them, rather than being passed as process environment variables.

**Docker Network vs Host Network**
Using the host network (`network: host`) removes network isolation between the container and the Docker host, which is forbidden in this project. A custom Docker network (like the bridge network used here) provides DNS resolution between containers using their service names and isolates the stack's internal traffic from the outside world.

**Docker Volumes vs Bind Mounts**
Bind mounts map a specific file or directory from the host machine directly into the container. Docker Volumes are managed entirely by Docker, meaning Docker handles their storage location and permissions, making them easier to back up, migrate, and share safely among containers. I am using named volumes mapped to `/home/hkasamat/data/` for persistent storage.