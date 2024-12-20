#!/bin/bash

source .env

microservices=(
  "analytics"
  "authenticator"
  "email"
  "foodNet-backend"
  "reviews"
)

for microservice in "${microservices[@]}"; do
  cd "microservices"

  if [ -d "$microservice" ]; then
    echo "Repository $microservice exists, updating with git pull"
    cd "$microservice"
    git pull "https://$GIT_USERNAME@github.com/$GIT_USERNAME/$microservice.git"
  else
    echo "Cloning repository: $microservice"
    git clone "https://$GIT_USERNAME@github.com/$GIT_USERNAME/$microservice.git"
    cd "$microservice"
  fi

  cd "../.."

  echo "Building container: $microservice"

  if [ "$microservice" = "foodNet-backend" ]; then
    container="foodnet"
  else
    container=$microservice
  fi

  make stop "container=$container"
  make up "container=$container"

  sudo chmod -R 777 "microservices/$microservice"

  container_name="foodnet-docker_"$container"_1"

  if [ -d vendor ]; then
    docker exec -it "$container_name" rm -rf vendor
  fi

  if [ -d composer.lock ]; then
    docker exec -it "$container_name" rm composer.lock
  fi

  docker exec -it "$container_name" sh -c "yes | composer install"

  docker exec -it "$container_name" sh -c "php bin/console doctrine:database:create"

  docker exec -it "$container_name" sh -c "yes | php bin/console doctrine:migrations:migrate"

  docker exec -it "$container_name" sh -c "exit"

done

make start

echo "Build completed!"