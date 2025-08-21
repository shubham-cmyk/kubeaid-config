{
  platform: 'kubeadm',
  extra_configs: true,
  'blackbox-exporter': true,
  connect_obmondo: true,
  connect_keda: false,
  grafana_keycloak_enable: true,
  grafana_root_url: 'https://grafana.vpn.obmondo.com',
  grafana_keycloak_url: 'https://keycloak.obmondo.com',
  grafana_keycloak_realm: 'Obmondo',
  grafana_ingress_host: 'grafana.vpn.obmondo.com',
  kube_prometheus_version: 'v0.15.0',
  enable_custom_metrics_apiservice: true,
  addMixins: {
    velero: true,
    monitoring: true,
  },
  prometheus_resources+: {
    limits: { memory: '256Mi' },
    requests: { cpu: '100m', memory: '256Mi' },
  },
  prometheus_adapter_resources+: {
    limits: { memory: '128Mi' },
    requests: { cpu: '20m', memory: '128Mi' },
  },
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik-cert-manager',
  },
  prometheus_scrape_namespaces: [
    'monitoring',
    'obmondo',
  ],
  prometheus+: {
    storage: {
      size: '20Gi',
    },
    retention: '15d',
  },
}
