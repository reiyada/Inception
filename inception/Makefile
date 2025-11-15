COMPOSE := docker compose
SRC_DIR := srcs

.PHONY: up build down logs clean fclean re

up:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml up -d

build:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml build --no-cache

down:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml down

logs:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml logs -f mariadb

clean: down

fclean: down
	sudo rm -rf /home/yourlogin/data/mariadb

re: fclean build up
