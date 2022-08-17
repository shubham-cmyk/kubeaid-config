#!/usr/bin/env bash

set -x
set -eou pipefail

# Don't run for merge requests that target a branch that is not master/main.
if [[ "${CI_COMMIT_REF_NAME}" != master ]] && [[ "${CI_COMMIT_REF_NAME}" != main ]]; then
  exit
fi

. ./bin/k8id_repo.sh

deploy_target_branch="${OBMONDO_DEPLOY_TARGET_BRANCH:-main}"
config_repo_path_k8id_config="/tmp/k8id_config"

git config --global user.email "${GITLAB_USER_EMAIL}"
git config --global user.name "${GITLAB_USER_NAME}"

git clone "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}" "${config_repo_path_k8id_config}"

git -C "${config_repo_path_k8id_config}" checkout -b "argocd-deploy" --track "origin/${deploy_target_branch}"

# Loop over all clusters that are defined in config repo and copy
# corresponding compiled files into cloned repo.
find "${config_repo_path_k8id_config}/k8s/" -mindepth 1 -maxdepth 1 -type d -not -name .\* | while read -r cluster_dir; do
  "/tmp/k8id/build/kube-prometheus/build.sh" "$cluster_dir"
  git -C "${config_repo_path_k8id_config}" add -f "${cluster_dir}"
done

# Check if we have modifications to commit
CHANGES=$(git -C "${config_repo_path_k8id_config}" status --porcelain | wc -l)

if (( CHANGES > 0)); then
  title='Updated Prometheus builds'

  git -C "${config_repo_path_k8id_config}" status
  git -C "${config_repo_path_k8id_config}" commit -m "${title}"

  # shellcheck disable=SC2094
  output=$(2>&1 git -C "${config_repo_path_k8id_config}" push \
                --force-with-lease \
                -o merge_request.create \
                -o merge_request.target="${deploy_target_branch}" \
                -o merge_request.title="${title}" \
                -o merge_request.remove_source_branch \
                -o merge_request.description="Auto-generated pull request from Obmondo, created from changes by ${GITLAB_USER_NAME} (${GITLAB_USER_EMAIL})." \
                origin HEAD)
  echo "${output}"

  if grep -q WARNINGS <<< "${output}"; then
    exit 1
  fi
fi
#                -o merge_request.merge_when_pipeline_succeeds \
