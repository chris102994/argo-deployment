#!/bin/bash

set -e # Exit on error
set -u # Unset variables are an error
#set -o xtrace # Print commands to terminal

APP_DIR="apps/"
APP_DIRS=(`find "${APP_DIR}" -maxdepth 1 -mindepth 1 -type d`)
HELM_LOCATION=$(which helm | true)
KUBECTL_LOCATION=$(which kubectl)

IGNORE_LIST=("argo-events", "argo-rollouts", "argo-workflows", "argocd", "metallb-load-balancer", "nginx-ingress")

for APP in "${APP_DIRS[@]}"; do
  if [[ ! "${IGNORE_LIST[*]}" =~ "${APP//$APP_DIR}" ]]; then
    DEPLOY_FILE="${APP//$APP_DIR}_deployment.yaml"
    echo -e "${DEPLOY_FILE}"
    if [ "${HELM_LOCATION:-UNDEFINED}" != "UNDEFINED" ]; then
      "${KUBECTL_LOCATION}" kustomize "${APP}" -o "${DEPLOY_FILE}" --enable-helm --helm-command "${HELM_LOCATION}"
    else
      "${KUBECTL_LOCATION}" kustomize "${APP}" -o "${DEPLOY_FILE}"
    fi
    "${KUBECTL_LOCATION}" apply -f "${DEPLOY_FILE}"
  else
    echo -e "Ignoring ${APP}"
  fi
done