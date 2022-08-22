# Adding more charts

## Create a chart

To create your own helm chart, run:

```bash
helm create <chart-name>
```

Put the created folder in the current directory (argocd-helm-chart).

Now this will give you the bare minimum skeleton for your chart. Which has the default setup ready to push the
application to the cluster with `nginx` image to run on the pod.

This image can be changed to the image you want to use. (Pushed to public/private repositories).
Please check the [images](https://gitlab.enableit.dk/obmondo/dockerfiles) that we have cached on our own repository.

### Sync the  chart to the cluster

- #### Create the manifest file for ArgoCD

  - Create the ArgoCD manifest file for the chart, and put it under the
  `kam.obmondo.com`/`kbm.obmondo.com` clusters depending on the need. Lets say you have to run the application in
  kbm cluster path will be `k8s/kbm.obmondo.com/argocd-apps/templates/<chart-name>.yaml`.
  - Put the values file for the chart (if required) in argocd-apps. Put the empty file if NO values are to be set,
      that's ok.

- #### Create the application

  - Head to the ArgoCD [dashboard](https://argocd.kbm.obmondo.com) (Cluster specific) and create the new application.
  - Important step in this process is SOURCE configuration.
    - `Repository URL` is the url of the repository where you have the chart.
    - `Revision` is the branch you want to follow or the tag you want to use.
    - `Path` is the relative path of the chart in the repository.

- #### Sync the application

  - Once the application is created in the ArgoCD, you will see that application is not synced to the cluster.
  This is because we have set the sync policy to `Manual` (Keep it manual).
  - To sync the application to the cluster, click on the application and click on the `Sync` button.
  - This will create the required services/deployments/ingress according to the helm configuration.

## Examples

We have a lot of [examples](https://gitlab.enableit.dk/kubernetes/k8id/-/tree/master/argocd-helm-charts)
of how to configure helm chart. Do check them out according to your need.
