# This file contains the default variables used in the Makefile
HOST_USER_ID=`id -u` # This works for linux. If it doesnt work on your OS, duplicate this file naming it "Makefile.defaults.custom.mk" and hardcode your host user ID there
PROJECT='php8-xdebug3-docker'
DOCKER_NETWORK='php8-xdebug3-docker-network'
HOST_IP=`docker network inspect ${DOCKER_NETWORK} | grep Gateway | awk '{print $$2}' | tr -d '"'`
