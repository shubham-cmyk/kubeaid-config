{
  platform: "kubeadm",
  extra_configs: true,
  "blackbox-exporter": false,
  connect_obmondo: true,
  connect_keda: false,
  grafana_keycloak_enable: true,
  grafana_root_url: "https://grafana.kcm.obmondo.com",
  grafana_keycloak_url: 'https://keycloak.obmondo.com',
  grafana_keycloak_realm: 'Obmondo',
  grafana_ingress_host: 'grafana.kcm.obmondo.com',
  kube_prometheus_version: "v0.15.0",
  enable_custom_metrics_apiservice: true,
  addMixins: {
    velero: true,
    monitoring: true,
    smartmon: true,
    zfs: true,
    mdraid: true,
    ceph: true,
  },
  prometheus_operator_resources+: {
    limits: { memory: "120Mi" },
    requests: { cpu: "10m", memory: "30Mi" },
  },
  alertmanager_resources+: {
    limits: { memory: "200Mi" },
    requests: { cpu: "10m", memory: "20Mi" },
  },
  prometheus_resources+: {
    limits: { memory: "5Gi" },
    requests: { cpu: "200m", memory: "500Mi" },
  },
  prometheus_adapter_resources+: {
    limits: { memory: '2Gi' },
    requests: { cpu: '200m', memory: '2Gi' },
  },
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik',
  },
  prometheus_scrape_namespaces: [
    'rook-ceph',
    'logging',
    'velero',
    'monitoring',
    'obmondo',
    'zfs-localpv',
    'obmondo-website',
    'finance',
  ],
  prometheus_scrape_default_namespaces: [
    "argocd",
    "sealed-secrets",
    "cert-manager",
  ],
  prometheus+: {
    storage: {
      size: "50Gi",
      classname: 'rook-ceph-block'
    },
    retention: "15d",
  },
}
