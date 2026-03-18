# User Documentation

This document explains how an end user or administrator can interact with the Inception infrastructure.

## Services Provided
This stack provides a fully functional, containerized web environment consisting of:
* **NGINX:** The single entrypoint to the infrastructure, acting as a web server accessible only via HTTPS (port 443) using TLSv1.2 or TLSv1.3.
* **WordPress + PHP-FPM:** The content management system hosting the website.
* **MariaDB:** The database securely storing the WordPress site data.

## Start and Stop the Project
* **To Start:** Navigate to the root of the project and run `make`. Alternatively, if the images are already built, run `docker compose -f srcs/docker-compose.yml up -d`.
* **To Stop:** Navigate to the root of the project and run `make clean` or `make fclean`.Run `docker compose -f srcs/docker-compose.yml down` to stop and remove the containers.

## Access the Website and Administration Panel
* **Website:** Open your web browser and navigate to `https://hkasamat.42.fr`. 
* **Admin Panel:** Navigate to `https://hkasamat.42.fr/wp-admin/` or `https://hkasamat.42.fr/wp-login.php` and log in with the administrator credentials.

## Locate and Manage Credentials
For security reasons, credentials are not stored in the Git repository. They are injected into the containers at runtime using Docker Secrets. To manage or change these, the administrator must modify the local text files located in the `secrets/` directory on the host machine and recreate the containers. The `secrets/` directory can be copied into the Git repository during evaluation.

## Check Services are Running Correctly
You can check the status of the services by running:
`docker compose -f srcs/docker-compose.yml ps`
This will list all containers and show if they are "Up" or continually restarting.