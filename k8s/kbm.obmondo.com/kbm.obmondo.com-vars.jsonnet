{
  platform: 'kubeadm',
  extra_configs: true,
  'blackbox-exporter': false,
  connect_obmondo: true,
  connect_keda: true,
  grafana_keycloak_enable: true,
  grafana_root_url: 'https://grafana.kbm.obmondo.com',
  grafana_keycloak_url: 'https://keycloak.obmondo.com',
  grafana_keycloak_realm: 'Obmondo',
  grafana_ingress_host: 'grafana.kbm.obmondo.com',
  kube_prometheus_version: 'v0.13.0',
  enable_custom_metrics_apiservice: true,
  addMixins: {
    velero: true,
    rabbitmq: true,
    monitoring: true,
  },
  prometheus_operator_resources+: {
    limits: { memory: '120Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources+: {
    limits: { memory: '50Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },
  prometheus_resources+: {
    limits: { memory: '7Gi' },
    requests: { cpu: '200m', memory: '5Gi' },
  },
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik-cert-manager',
  },
  prometheus_scrape_namespaces: [
    'rook-ceph',
    'logging',
    'velero',
    'monitoring',
    'obmondo',
    'zfs-localpv'
  ],
  prometheus+: {
    storage: {
      size: '60Gi',
      classname: 'rook-ceph-block',
    },
    retention: '15d',
  },
}
