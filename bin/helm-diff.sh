#!/usr/bin/env bash

set -x
set -eou pipefail

. ./bin/k8id_repo.sh

ARGOCD_APPS_PATH="argocd-apps"
K8ID_CONFIG_REPO="/tmp/k8id_config"
K8ID_ARGOCD_HELM_CHARTS="/tmp/k8id/argocd-helm-charts"

# NOTE: git diff does not work, cause gitlab only checkout only one branch
# so there is nothing to compare.
git clone "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}" "$K8ID_CONFIG_REPO"

# SKIP diff check part IF MR conststs of ONLY commits with word 'lint' in them
COMMIT_MSG=$(git -C /tmp/k8id_config log --oneline --pretty=format:'%s' --abbrev-commit "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" k8s/**/$ARGOCD_APPS_PATH)

COMMIT_COUNT=$(echo "$COMMIT_MSG" | wc -l)
LINT_COUNT=$(echo "$COMMIT_MSG" | { grep '^lint' -c || true; } )
DOC_COUNT=$(echo "$COMMIT_MSG" | { grep '^doc' -c || true; } )

function helm_diff() {
  chart_path="$K8ID_ARGOCD_HELM_CHARTS/${1}"
  chart_name="$1"
  value_file="$2"

  # Move to the local branch
  git -C "$K8ID_CONFIG_REPO" checkout "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"

  # if incase the target branch code has some bug
  helm template "$chart_path" -f "${chart_path}/values.yaml" -f "/tmp/k8id_config/$value_file" > "/tmp/${chart_name}_master.yaml" || true

  # Move to the local branch
  git -C "$K8ID_CONFIG_REPO" checkout "$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME"

  # Check if the helm chart exists in the feature branch
  if test -d "$chart_path"; then
    helm template "$chart_path" -f "${chart_path}/values.yaml" -f "/tmp/k8id_config/$value_file" > "/tmp/${chart_name}_local.yaml"

    any_diff=$(diff -u "/tmp/${chart_name}_master.yaml" "/tmp/${chart_name}_local.yaml" || true )

    if diff -u "/tmp/${chart_name}_master.yaml" "/tmp/${chart_name}_local.yaml"; then
      echo "There is no changes based on the changes, not good"
      exit 1
    else
      echo "Nice, there is a diff between changes"
      echo "$any_diff"
    fi
  else
    echo "Helm chart removed"
  fi
}

function helm_compile() {
  chart_path="$K8ID_ARGOCD_HELM_CHARTS/${1}"
  chart_name="$1"
  value_file="$2"

  git -C "$K8ID_CONFIG_REPO" checkout "$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME"

  if helm template "$chart_name" -f "${chart_name}/values.yaml" -f "/tmp/k8id_config/$value_file"; then
    echo "Nice, Helm template works with the given values files"
  else
    echo "Ouch!! Helm template fails, please run this command to verify locally first"
    echo "helm template $chart_name -f ${chart_name}/values.yaml -f k8id_config/$value_file"
    exit 1
  fi
}

# Only get the directory name of the chart
git -C "$K8ID_CONFIG_REPO" diff "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" --name-only | grep 'argocd-apps/value*' | sort | uniq | while read -r diff; do

  chart_name=$(echo "$diff" | awk -F '/' '{print $NF}' | cut -d '-' -f2 | cut -d '.' -f1)

  if [ "$COMMIT_COUNT" -eq "$LINT_COUNT" ]; then
    helm_compile "$chart_name" "$diff"
  elif [ "$COMMIT_COUNT" -eq "$DOC_COUNT" ]; then
    helm_compile "$chart_name" "$diff"
  else
    helm_diff "$chart_name" "$diff"
  fi
done
