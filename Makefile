# Variables
include ./srcs/.env.example

SECRETS_DIR = secrets
COMPOSE_FILE = ./srcs/docker-compose.yml

MYSQL_PASS_MAKE := $(shell openssl rand -base64 20)
MYSQL_ROOT_PASS_MAKE := $(shell openssl rand -base64 20)
WP_ADMIN_PASS_MAKE := $(shell openssl rand -base64 20)
WP_COMMON_PASS_MAKE := $(shell openssl rand -base64 20)

# Colors
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
RESET := \033[0m

# Rules
all: build
	@mkdir -p $(SECRETS_DIR)
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@if [ ! -f "./srcs/.env" ]; then \
		printf "⚠️ ${BLUE}Warning: ${RESET} setting up default .env file!\n"; \
		cp ./srcs/.env.example ./srcs/.env; \
		echo "$(MYSQL_ROOT_PASS_MAKE)" > $(SECRETS_DIR)/db_root_password.txt; \
		echo "$(MYSQL_PASS_MAKE)" > $(SECRETS_DIR)/db_password.txt; \
		echo "$(WP_ADMIN_PASS_MAKE)" > $(SECRETS_DIR)/wp_admin_password.txt; \
		echo "$(WP_COMMON_PASS_MAKE)" > $(SECRETS_DIR)/wp_common_password.txt; \
		echo "127.0.0.1  $(DOMAIN_NAME)" | sudo tee -a /etc/hosts > /dev/null; \
	else \
		printf "⚠️ ${BLUE}Warning: ${RESET} using already generated .env file!\n"; \
	fi

manual:
	@mkdir -p $(SECRETS_DIR)
	@rm -f ./srcs/.env
	@echo "MYSQL_DATABASE=wordpress" >> ./srcs/.env;
	@echo  "We need to set up $(RED)enviroment$(RESET) variables"
	@echo  "Type in accordingly or leave blank for default"
	@read -p "MySQL user [$(MYSQL_USER)]: " sql_user; \
	echo "MYSQL_USER=$${sql_user:-$(MYSQL_USER)}" >> ./srcs/.env
	@read -s -p "MySQL root password [$(MYSQL_ROOT_PASS_MAKE)]: " db_root_pass; echo ""; \
	echo "$${db_root_pass:-$(MYSQL_ROOT_PASS_MAKE)}" > $(SECRETS_DIR)/db_root_password.txt
	@read -s -p "MySQL user password [$(MYSQL_PASS_MAKE)]: " db_pass; echo ""; \
	echo "$${db_pass:-$(MYSQL_PASS_MAKE)}" > $(SECRETS_DIR)/db_password.txt
	@read -p "Wordpress admin user [$(WP_ADMIN_USER)]: " wp_admin; \
	echo "WP_ADMIN_USER=$${wp_admin:-$(WP_ADMIN_USER)}" >> ./srcs/.env
	@read -p "Wordpress admin email [$(WP_ADMIN_EMAIL)]: " wp_admin_email; \
	echo "WP_ADMIN_EMAIL=$${wp_admin_email:-$(WP_ADMIN_EMAIL)}" >> ./srcs/.env
	@read -s -p "Wordpress admin password [$(WP_ADMIN_PASS_MAKE)]: " wp_admin_pass; echo ""; \
	echo "$${wp_admin_pass:-$(WP_ADMIN_PASS_MAKE)}" > $(SECRETS_DIR)/wp_admin_password.txt
	@read -p "Wordpress common user [$(WP_SECOND_USER)]: " wp_second; \
	echo "WP_SECOND_USER=$${wp_second:-$(WP_SECOND_USER)}" >> ./srcs/.env
	@read -p "Wordpress common user email [$(WP_SECOND_EMAIL)]: " wp_second_email; \
	echo "WP_SECOND_EMAIL=$${wp_second_email:-$(WP_SECOND_EMAIL)}" >> ./srcs/.env
	@read -s -p "Wordpress common user password [$(WP_COMMON_PASS_MAKE)]: " wp_common_pass; echo ""; \
	echo "$${wp_common_pass:-$(WP_COMMON_PASS_MAKE)}" > $(SECRETS_DIR)/wp_common_password.txt
	@echo "DOMAIN_NAME=$(DOMAIN_NAME)" >> ./srcs/.env

build:
	@printf "💻 ${GREEN}Building: ${RESET}docker images in background\n"
	@docker-compose -f $(COMPOSE_FILE) build> /dev/null 2>&1
	@printf "💻 ${GREEN}Building: ${RESET}finished!\n"

up:
	@printf "🔥 ${YELLOW}Starting: ${RESET}docker images in background\n"
	@docker-compose -f $(COMPOSE_FILE) up -d > /dev/null 2>&1
	@sleep 2
	@printf "🔥 ${YELLOW}Starting: ${RESET}containers are live!\n"

stop:
	@printf "⛔ ${BLUE}Stopping: ${RESET} containers are being shut down\n"
	@docker-compose -f $(COMPOSE_FILE) stop> /dev/null 2>&1
	@printf "⛔ ${BLUE}Stopping: ${RESET} containers are down!\n"

status:
	@printf "📜 ${YELLOW}Logging: ${RESET} getting log files for each service\n"
	@docker-compose -f $(COMPOSE_FILE) logs > logs.txt
	@printf "📜 ${YELLOW}Logging: ${RESET} logs.txt generated!\n"

restart:
	@printf "🔄 ${RED}Restarting: ${RESET} services are being restarted\n"
	@docker-compose -f $(COMPOSE_FILE) restart > /dev/null 2>&1
	@printf "🔄 ${RED}Restarting: ${RESET} finished restarting!\n"

clean: stop
	@printf "🧹 ${RED}Cleaning: ${RESET} destroying network and live containers!\n"
	@docker-compose -f $(COMPOSE_FILE) down > /dev/null 2>&1
	@printf "🧹 ${RED}Cleaning: ${RESET} containers and networks are clean!\n"

fclean: clean
	@printf "💣 ${RED}Deep cleaning: ${RESET} removing images, env file and volumes\n"
	@docker system prune -af --volumes > /dev/null 2>&1
	@sudo rm -rf /home/$(USER)/data/wordpress
	@sudo rm -rf /home/$(USER)/data/mariadb
	@rm -rf $(SECRETS_DIR) ./srcs/.env
	@printf "💣 ${RED}Deep cleaning: ${RESET} everything clean!\n"


re: fclean all

.PHONY: all restart manual up down build clean fclean re
