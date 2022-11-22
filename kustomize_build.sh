#!/bin/bash

set -e # Exit on error
set -u # Unset variables are an error

APP_DIR="apps/"
APP_DIRS=(`find "${APP_DIR}" -maxdepth 1 -mindepth 1 -type d`)
HELM_LOCATION=$(which helm)

IGNORE_LIST=("argo", "argo-events")

for APP in "${APP_DIRS[@]}"; do
  if [[ ! "${IGNORE_LIST[*]}" =~ "${APP//$APP_DIR}" ]]; then
    DEPLOY_FILE="${APP//$APP_DIR}_deployment.yaml"
    echo -e "${DEPLOY_FILE}"
    kubectl kustomize "${APP}" -o "${DEPLOY_FILE}" --enable-helm --helm-command "${HELM_LOCATION}"
    kubectl apply -f "${DEPLOY_FILE}"
  fi
done

kubectl apply -f secrets.yaml