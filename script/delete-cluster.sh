#!/usr/bin/env bash

set -xe

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/common.sh

kind delete cluster --name $CLUSTER_NAME