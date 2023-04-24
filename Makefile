help:
	@echo 'Make file'

build:
	@sudo docker-compose -f docker-compose.yml up -d --build --remove-orphans

up:
	@sudo docker-compose -f docker-compose.yml up -d

down:
	@sudo docker-compose -f docker-compose.yml down

shell:
	@sudo docker exec -it $(sudo docker container ls  | grep foodnet-docker_$(container) | awk '{print $1}') bash