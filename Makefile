DEFAULT_CONTAINER = foodnet

help:
	@echo '--------------------'
	@echo 'Make file:'
	@echo '--------------------'
	@echo 'make up						- build and start project containers'
	@echo 'make down					- stop and remove project containers'
	@echo 'make start					- start project containers'
	@echo 'make stop					- stop project containers'
	@echo 'make shell [container]		- enter PHP-fpm container'

up:
	@docker-compose -f docker-compose.yml up -d --build --remove-orphans

down:
	@docker-compose -f docker-compose.yml down

start:
	@docker-compose -f docker-compose.yml start

stop:
	@docker-compose -f docker-compose.yml stop

shell:
	@docker exec -it $$(docker ps | grep 'foodnet-docker_$(if $(container),$(container),$(DEFAULT_CONTAINER))' | awk '{ print $$1 }') bash
