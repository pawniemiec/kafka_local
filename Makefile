.PHONY: help start build test stop bash

DOCKER_NAME = kafka_local
ENV_FILE = $(PWD)/.env

ifneq ("$(wildcard $(ENV_FILE))", "")
	include $(ENV_FILE)
	export $(shell sed 's/=.*//' $(ENV_FILE))
endif

help: ##  shows all available targets
	@echo ""
	@echo "Kafka local service"
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\)\:.*##/\1:/'
	@echo ""

start: ## starts kafka service
	docker-compose up -d

build: ## builds/downloads kafka docker image
	docker-compose build

test: ##  run tests
	tests/test_kafka_brokers_exist.sh localhost 2182 ids

stop: ##  stops kafka service
	docker-compose down

bash: ##  login to container
	docker exec -it `docker-compose ps -q` /usr/bin/env bash
