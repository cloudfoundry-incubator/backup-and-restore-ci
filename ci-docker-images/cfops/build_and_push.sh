#!/bin/bash -e

pushd $(dirname $0)
docker pull ubuntu:trusty
docker build -t cloudfoundrylondon/cfops .
docker push cloudfoundrylondon/cfops:latest
popd
