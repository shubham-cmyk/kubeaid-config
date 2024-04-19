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
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik-cert-manager',
  },
  prometheus_scrape_namespaces: [
    'rook-ceph',
    'logging',
    'velero',
    'monitoring',
    'obmondo'
  ],
  prometheus+: {
    storage: {
      size: '45Gi',
      classname: 'rook-ceph-block',
    },
    retention: '15d',
  },
}
