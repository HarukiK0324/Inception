COMPOSE_FILE = srcs/docker-compose.yml

DATA_DIR = /home/hkasamat/data

all: up

up:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:Z
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@sudo rm -rf $(DATA_DIR)/mariadb/*
	@sudo rm -rf $(DATA_DIR)/wordpress/*
	@docker system prune -af

re: fclean all

.PHONY: all up down clean fclean re