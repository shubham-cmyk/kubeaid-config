# `kubernetes-config`

Customer specific files for kubernetes clusters.

## How to build kube-prometheus

Run the argocd-apps repos pipeline. It will create a kubernetes-config-enableit MR, with the new prometheus manifests.

## Lint file

### YAML

- `sudo apt-get install yamllint`
- `yamllint .`

### Markdown

`npx --yes markdownlint-cli --config .markdownlint .` *Assuming node js is install on the system*
