{
  platform: "kubeadm",
  extra_configs: true,
  "blackbox-exporter": false,
  connect_obmondo: false,
  connect_keda: false,
  grafana_keycloak_enable: false,
  grafana_root_url: "https://grafana.vpn.obmondo.com",
  kube_prometheus_version: "v0.17.0",
  enable_custom_metrics_apiservice: true,
  prometheus_operator_resources+: {
    limits: { memory: "80Mi" },
    requests: { cpu: "10m", memory: "30Mi" },
  },
  alertmanager_resources+: {
    limits: { memory: "50Mi" },
    requests: { cpu: "10m", memory: "20Mi" },
  },
  prometheus_resources+: {
    limits: { memory: "1Gi" },
    requests: { cpu: "200m", memory: "500Mi" },
  },
  // Upstream kube-prometheus default reserves 1500Mi/2Gi for the adapter
  // (a metrics-API shim that uses ~50Mi) — too heavy for this single
  // cpx32 node and it blocks scheduling (e.g. the NetBird router pod).
  prometheus_adapter_resources+: {
    limits: { memory: "512Mi" },
    requests: { cpu: "100m", memory: "150Mi" },
  },
  prometheus_adapter_replicas: 1,
  // Traefik ingresses for the monitoring UIs. TLS via the cluster's
  // letsencrypt-prod ClusterIssuer (kube-prometheus defaults the
  // annotation to "letsencrypt", which doesn't exist here); ingress
  // class set via annotation since the kube-prometheus ingress template
  // doesn't accept a className.
  prometheus_ingress_host: "prometheus.vpn.obmondo.com",
  grafana_ingress_host: "grafana.vpn.obmondo.com",
  alertmanager_ingress_host: "alertmanager.vpn.obmondo.com",
  prometheus_ingress_annotations: {
    "cert-manager.io/cluster-issuer": "letsencrypt-prod",
    "kubernetes.io/ingress.class": "traefik",
  },
  grafana_ingress_annotations: {
    "cert-manager.io/cluster-issuer": "letsencrypt-prod",
    "kubernetes.io/ingress.class": "traefik",
  },
  alertmanager_ingress_annotations: {
    "cert-manager.io/cluster-issuer": "letsencrypt-prod",
    "kubernetes.io/ingress.class": "traefik",
  },
  prometheus_scrape_namespaces: [],
  prometheus_scrape_default_namespaces: [
    "argocd",
    "sealed-secrets",
    "cert-manager",
  ],
  prometheus+: {
    storage: {
      size: "10Gi",
    },
    retention: "15d",
  },
}
