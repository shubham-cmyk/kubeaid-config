#!/usr/bin/env bash

set -eou pipefail

if ! [[ "${KUBERNETES_CONFIG_REPO_URL}" && "${KUBERNETES_CONFIG_REPO_TOKEN}" ]]; then
    >&2 echo "Required variables KUBERNETES_CONFIG_REPO_URL and KUBERNETES_CONFIG_REPO_TOKEN are unset.'."
  exit 42
fi

if ! [[ "${CI}" ]]; then
  >&2 echo "This script should only be run in a CI pipeline. This is not a CI pipeline."
  exit 41
fi

case "${KUBERNETES_CONFIG_REPO_URL}" in
  *gitlab*)
    config_repo_username=oauth2
    config_repo_password="${KUBERNETES_CONFIG_REPO_TOKEN}"
    config_repo_auth="${config_repo_username}:${config_repo_password}"
    ;;
  *github*)
    config_repo_username="${KUBERNETES_CONFIG_REPO_TOKEN}"
    config_repo_password=''
    config_repo_auth="${config_repo_username}"
esac

if ! [[ "${config_repo_auth}" ]]; then
  >&2 echo "Missing repo access token"
  exit 43
fi

if ! [[ "${KUBERNETES_CONFIG_REPO_URL}" =~ ^https://(.+) ]]; then
  >&2 echo "Unable to handle Kubernetes repo URL '${KUBERNETES_CONFIG_REPO_URL}'"
  exit 44
fi

config_repo_url_with_auth="https://${config_repo_auth}@${KUBERNETES_CONFIG_REPO_URL:8}"
config_repo_name=$(echo "$KUBERNETES_CONFIG_REPO_URL" | sed -r "s/.+\/(.+)\..+/\1/")
config_repo_path_k8id="/tmp/k8id"

git clone "${config_repo_url_with_auth}" "${config_repo_path_k8id}"
