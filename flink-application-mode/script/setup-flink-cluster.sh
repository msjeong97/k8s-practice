#!/usr/bin/env bash

set -xe

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# for idempotent
bash $SCRIPT_DIR/../script/delete-cluster.sh
bash $SCRIPT_DIR/../script/create-cluster.sh

docker pull flink:1.18.1-scala_2.12-java11

kubectl create namespace flink
kubectl config set-context --current --namespace=flink

