#!/bin/bash
VERSAO_ATUAL=""
NOVA_VERSAO=$(date +'%d-%m-%Y-%H-%M-%S')


get_current_version(){
    echo "Pegando a versao atual da Docker Image"
    VERSAO_ATUAL=$(docker images | grep app-imagem | awk '{print $2}' | head -n 1)
    echo "Versao atual é: $VERSAO_ATUAL"
}

build_image(){
    echo "Construindo a Docker Image, app-imagem:$NOVA_VERSAO"
    docker build -t app-imagem:$NOVA_VERSAO .
}

run_container(){
    if [ "$(docker ps -a | grep app-container)" ]; then
        echo "Parando o Container..."
        docker kill app-container
    fi
    echo "Rodando a nova versao"
    docker run --rm -d -p 8080:8080 --name app-container app-imagem:$1
}

health_check(){
  if [ "$(docker ps | grep app-container | grep unhealthy)" ]; then
      echo "Health check failed"
      rollback
  else
      echo "Health check passed"
  fi
}

waiting_for_new_version(){
    echo "Waiting for New Version"
    sleep 20
}

rollback(){
    echo "Rollback deploy"
    docker rmi app-imagem:$NOVA_VERSAO
    run_container $VERSAO_ATUAL
    exit 1
}

clear_docker_images() {
  docker image prune --force
}

get_current_version
build_image
run_container $NOVA_VERSAO
waiting_for_new_version
health_check
clear_docker_images
