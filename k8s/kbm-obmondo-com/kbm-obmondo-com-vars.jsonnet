{
  platform: 'kubeadm',
  extra_configs: true,
  'blackbox-exporter': false,
  connect_obmondo: true,
  // certname is required by kubeaid's kube-prometheus common-template when
  // connect_obmondo is true. It's the Subject CN of the Obmondo-issued cert
  // (same cert kubeaid-agent uses for mTLS to the Obmondo API) — read and
  // passed in by getTemplateValues.
  certname: 'kbm.enableit',
  connect_keda: false,
  grafana_keycloak_enable: false,
  grafana_root_url: '',
  kube_prometheus_version: 'v0.17.0',
  enable_custom_metrics_apiservice: true,
  prometheus_operator_resources+: {
    limits: { memory: '80Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources+: {
    limits: { memory: '50Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },
  prometheus_resources+: {
    limits: { memory: '1Gi' },
    requests: { cpu: '200m', memory: '500Mi' },
  },
  prometheus_ingress_host: 'prometheus.kbm.obmondo.com',
  grafana_ingress_host: 'grafana.kbm.obmondo.com',
  alertmanager_ingress_host: 'alertmanager.kbm.obmondo.com',
  prometheus_ingress_annotations: {
    'cert-manager.io/cluster-issuer': 'letsencrypt-prod',
    'kubernetes.io/ingress.class': 'traefik',
  },
  grafana_ingress_annotations: {
    'cert-manager.io/cluster-issuer': 'letsencrypt-prod',
    'kubernetes.io/ingress.class': 'traefik',
  },
  alertmanager_ingress_annotations: {
    'cert-manager.io/cluster-issuer': 'letsencrypt-prod',
    'kubernetes.io/ingress.class': 'traefik',
  },
  prometheus_scrape_namespaces: [],
  prometheus_scrape_default_namespaces: [
    'argocd',
    'sealed-secrets',
    'cert-manager',
  ],
  prometheus+: {
    storage: {
      size: '10Gi',
    },
    retention: '15d',
  },
}
