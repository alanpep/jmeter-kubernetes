#!/bin/bash -e

docker build --tag="kubernautslabs/jmeter-base:latest" -f ../docker/Dockerfile-base .
docker build --tag="kubernautslabs/jmeter-master:latest" -f ../docker/Dockerfile-master .
docker build --tag="kubernautslabs/jmeter-slave:latest" -f ../docker/Dockerfile-slave .
docker build --tag="kubernautslabs/jmeter-reporter" -f ../docker/Dockerfile-reporter .
