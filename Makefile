# Makefile
#
# This file contains the commands most used in DEV, plus the ones used in CI and PRD environments.
#

# Execute targets as often as wanted
.PHONY: config

# Mute all `make` specific output. Comment this out to get some debug information.
.SILENT:

# make commands be run with `bash` instead of the default `sh`
SHELL='/bin/bash'

include Makefile.defaults.mk
ifneq ("$(wildcard Makefile.defaults.custom.mk)","")
  include Makefile.defaults.custom.mk
endif

# .DEFAULT: If the command does not exist in this makefile
# default:  If no command was specified
.DEFAULT default:
	if [ -f ./Makefile.custom.mk ]; then \
	    $(MAKE) -f Makefile.custom.mk "$@"; \
	else \
	    if [ "$@" != "default" ]; then echo "Command '$@' not found."; fi; \
	    $(MAKE) help; \
	    if [ "$@" != "default" ]; then exit 2; fi; \
	fi

help:  ## Show this help
	@echo "Usage:"
	@echo "     [ARG=VALUE] [...] make [command]"
	@echo "     make env-status"
	@echo "     NAMESPACE=\"dummy-app-namespace\" RELEASE_NAME=\"another-dummy-app\" make env-status"
	@echo
	@echo "Available commands:"
	@grep '^[^#[:space:]].*:' Makefile | grep -v '^default' | grep -v '^\.' | grep -v '=' | grep -v '^_' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}' | sed 's/://'

########################################################################################################################

###############################
## Docker
###############################

docker-setup:
	-docker network create ${DOCKER_NETWORK}
	docker network inspect ${DOCKER_NETWORK} | grep Gateway | awk '{print $$2}' | tr -d '"'

docker-up:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} PROJECT=${PROJECT} docker-compose -f docker/docker-compose.yml up

docker-down:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} PROJECT=${PROJECT} docker-compose -f docker/docker-compose.yml down

docker-logs:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} PROJECT=${PROJECT} docker-compose -f docker/docker-compose.yml logs -f

docker-shell:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} PROJECT=${PROJECT} docker-compose -f docker/docker-compose.yml exec phpfpm bash

docker-test:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} PROJECT=${PROJECT} docker-compose -f docker/docker-compose.yml run phpfpm sh -c 'make test'

###############################
## Run
###############################
run-php-ver:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} docker-compose -f docker/docker-compose.yml exec phpfpm sh -c "php -v"

run-php-reload:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} docker-compose -f docker/docker-compose.yml exec phpfpm sh -c "kill -USR2 1"

run-script:
	DOCKER_USER_ID=${HOST_USER_ID} HOST_IP=${HOST_IP} DOCKER_NETWORK=${DOCKER_NETWORK} docker-compose -f docker/docker-compose.yml exec phpfpm sh -c "php public/index.php"

run-website:
	python -m webbrowser "http://localhost:8083/"

###############################
## Testing
###############################
test: ## Run all tests
	./bin/phpunit

###############################
## Others
###############################
open-xdebug-port:
	sudo iptables -A INPUT -p tcp -d 0/0 -s 0/0 --dport 9003 -j ACCEPT
