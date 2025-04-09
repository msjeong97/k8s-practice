#!/usr/bin/env bash

set -xe

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# build jar
#cd $SCRIPT_DIR/example-streaming-job/
#./gradlew clean build
#cd $SCRIPT_DIR/

# for idempotent
bash $SCRIPT_DIR/../script/delete-cluster.sh
bash $SCRIPT_DIR/../script/create-cluster.sh

sleep 10

# build image and load to KinD cluster
# docker build -t flink-example-job:latest .
kind load docker-image flink:1.18.1-scala_2.12-java11 --name minseop-k8s

kubectl create namespace flink-session


# install k8s operator to the cluster
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator \
  --namespace flink-session \
  --set image.repository=apache/flink-kubernetes-operator \
  --set webhook.create=false
sleep 30

# create flink cluster
kustomize build cluster/kustomize | kubectl apply -f -

#sleep 10
kubectl port-forward service/flink-jobmanager 8081:8081
