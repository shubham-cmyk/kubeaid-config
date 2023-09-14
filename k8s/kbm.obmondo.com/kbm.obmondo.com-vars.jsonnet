{
  platform: 'kubeadm',
  extra_configs: true,
  'blackbox-exporter': false,
  connect_obmondo: true,
  connect_keda: true,
  grafana_keycloak_enable: true,
  grafana_root_url: 'https://grafana.kbm.obmondo.com',
  grafana_keycloak_url: 'https://keycloakx.kam.obmondo.com',
  grafana_keycloak_realm: 'Obmondo',
  grafana_ingress_host: 'grafana.kbm.obmondo.com',
  kube_prometheus_version: '2a955da550e33f75e3a7ecf30d45e8fd19dc6c31',
  enable_custom_metrics_apiservice: true,
  addMixins: {
    velero: true,
  },
  prometheus_operator_resources+: {
    limits: { memory: '80Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources+: {
    limits: { memory: '50Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },
  prometheus_resources+: {
    limits: { memory: '5Gi' },
    requests: { cpu: '200m', memory: '3Gi' },
  },
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik-cert-manager',
  },
  prometheus_scrape_namespaces: [
    'rook-ceph',
    'logging',
    'obmondo-website',
    'velero',
  ],
  prometheus+: {
    storage: {
      size: '30Gi',
      classname: 'rook-ceph-block',
    },
    retention: '15d',
  },
}
