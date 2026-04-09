{
  platform: 'kubeadm',
  certname: 'kam.enableit',
  extra_configs: true,
  'blackbox-exporter': false,
  connect_obmondo: true,
  grafana_keycloak_enable: true,
  grafana_root_url: 'https://grafana.kam.obmondo.com',
  grafana_ingress_host: 'grafana.kam.obmondo.com',
  grafana_keycloak_url: 'https://keycloak.obmondo.com',
  grafana_keycloak_realm: 'Obmondo',
  kube_prometheus_version: 'v0.13.0',
  addMixins: {
    'node-count-monthly-status': true,
    ceph: true,
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
    limits: { memory: '4Gi' },
    requests: { cpu: '800m', memory: '2Gi' },
  },
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik-cert-manager',
  },
  prometheus_scrape_namespaces: [
    'rook-ceph',
    'artoo',
    'mattermost',
    'obmondo',
    'obmondo-website',
    'finance',
  ],
  prometheus: {
    storage: {
      size: '40Gi',
      classname: 'rook-ceph-block',
    },
    retention: '15d',
  },
}
