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
	@printf "Setting up default configuration...\n"
	@cp ./srcs/.env.example ./srcs/.env
	@echo "$(MYSQL_ROOT_PASS_MAKE)" > $(SECRETS_DIR)/db_root_password.txt
	@echo "$(MYSQL_PASS_MAKE)" > $(SECRETS_DIR)/db_password.txt
	@echo "$(WP_ADMIN_PASS_MAKE)" > $(SECRETS_DIR)/wp_admin_password.txt
	@echo "$(WP_COMMON_PASS_MAKE)" > $(SECRETS_DIR)/wp_common_password.txt

manual:
	@mkdir -p $(SECRETS_DIR)
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
	@read -p "Domain name [$(DOMAIN_NAME)]: " domain; \
	echo "DOMAIN_NAME=$${domain:-$(DOMAIN_NAME)}" >> ./srcs/.env

build:
	@printf "💻 ${GREEN}Building: ${RESET}docker images in background\n"
	@docker-compose -f $(COMPOSE_FILE) build> /dev/null 2>&1
	@printf "💻 ${GREEN}DONE!${RESET}\n"

domain: fclean
	@cp ./srcs/.env.example ./srcs/.env
	@read -p "Type in the new domain name: " new_domain; \
	sed -i "\$$c\DOMAIN_NAME=$${new_domain}" ./srcs/.env; \
	sudo sed -i "/$(DOMAIN_NAME)/d" /etc/hosts; \
	echo "127.0.0.1  $${new_domain}" | sudo tee -a /etc/hosts > /dev/null
	@$(MAKE) all up

up:
	@printf "💻 ${YELLOW}Starting: ${RESET}docker images in background\n"
	@docker-compose -f $(COMPOSE_FILE) up -d> /dev/null 2>&1
	@printf "💻 ${YELLOW}LIVE!${RESET}\n"

stop:
	@printf "${BLUE}Stopping services...${RESET}\n"
	@docker-compose -f $(COMPOSE_FILE) stop> /dev/null 2>&1

destroy:
	@printf "${RED}Destroying services...${RESET}\n"
	@docker-compose -f $(COMPOSE_FILE) kill> /dev/null 2>&1
	@docker-compose -f $(COMPOSE_FILE) rm -f> /dev/null 2>&1

restart:
	@printf "${RED}Restarting services...${RESET}\n"
	@docker-compose -f $(COMPOSE_FILE) restart > /dev/null 2>&1

clean: stop
	@printf "${RED}Cleaning containers and networks...${RESET}\n"
	@docker-compose -f $(COMPOSE_FILE) down -v > /dev/null 2>&1

fclean: clean
	@printf "${RED}Deep cleaning: removing images and local volumes...${RESET}\n"
	@docker system prune -af > /dev/null 2>&1
	@sudo rm -rf /home/$(USER)/data/wordpress/*
	@sudo rm -rf /home/$(USER)/data/mariadb/*
	@rm -rf $(SECRETS_DIR) ./srcs/.env

re: fclean all

.PHONY: all restart destroy manual up down build clean fclean re
