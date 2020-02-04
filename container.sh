#!/usr/bin/env bash

#################################################################################
#  Helper Script to manage docker container.
#  Use:
#   ./container build     builds the image locally
#   ./container run       runs the built image, used after build command
#   ./container kill      kills all standalone-felix docker images
#  TIP: you can do ./container build run   and yes, order matters.
#################################################################################
NAME="standalone-felix"
PORT=8080
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    b|build)
        echo "Building Docker Container: $NAME"
        docker build -t $NAME -f "Dockerfile" .
        shift       # past argument
    ;;
    r|run)
        echo "Running Docker Container: $NAME"
        docker run -it -p $PORT:$PORT $NAME
        shift # past argument
    ;;
    k|kill)
        echo "Killing Docker Container: $NAME"
        docker ps | grep $NAME | awk '{print $1}' | xargs docker kill
        shift # past argument
    ;;
    # unknown option
    *)
        echo "Unknown argument: $key"
        shift # past argument
    ;;
esac
done
