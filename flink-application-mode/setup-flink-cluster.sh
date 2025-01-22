#!/usr/bin/env bash

set -xe

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# build jar
cd $SCRIPT_DIR/example-streaming-job/
./gradlew clean build
cd $SCRIPT_DIR/

# for idempotent
bash $SCRIPT_DIR/../script/delete-cluster.sh
bash $SCRIPT_DIR/../script/create-cluster.sh

sleep 10

# build image and load to KinD cluster
docker build -t flink-example-job:latest .
kind load docker-image flink-example-job:latest --name minseop-k8s

kubectl create namespace flink
kubectl config set-context --current --namespace=flink
kubectl create configmap flink-config --from-file=config/flink-conf.yaml --namespace flink

kustomize build kustomize | kubectl apply -f -

sleep 10
kubectl port-forward service/flink-jobmanager 8081:8081
