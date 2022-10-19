#!/bin/sh

set -e

echo "/usr/local/bin/kubectl" >> "$GITHUB_PATH"

if [ ! -d "${HOME}/.kube" ]; then
  mkdir -p "${HOME}/.kube"
fi

if [ ! -f "$HOME/.kube/config" ]; then
  if [ -z "$KUBE_CERTIFICATE" ] || [ -z "$KUBE_HOST" ] || [ -z "$KUBE_TOKEN" ] || [ -z "$KUBE_NAMESPACE" ]; then
    echo "No authorization data found. Please provide KUBE_HOST, KUBE_CERTIFICATE, KUBE_TOKEN and KUBE_NAMESPACE variables. Exiting..."
    exit 1
  fi

  echo "$KUBE_CERTIFICATE" | base64 -d >"${HOME}/.kube/certificate"

  kubectl config set-cluster default --server="https://${KUBE_HOST}" --certificate-authority="${HOME}/.kube/certificate"
  kubectl config set-credentials default --token="${KUBE_TOKEN}"
  kubectl config set-context default --cluster=default --namespace="$KUBE_NAMESPACE" --user=default
  kubectl config use-context default
fi

kubectl "${@}"
