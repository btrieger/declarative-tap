#@ load("@ytt:yaml", "yaml")
#@ load("@ytt:data", "data")
---
#@ def config():
tap:
  #! Set Backstage catalogs to include by default.
  version: "1.3.0"
  tbs:
    version: "1.7.0"
  catalogs:
  - https://gitlab.$DOMAIN_NAME/tap/tanzu-java-web-app/-/blob/main/catalog/catalog-info.yaml
  devNamespaces: 
    - dev-tap
  ca_cert_data:  #@ data.read("ca.crt")
  registry:
    host: harbor.$DOMAIN_NAME
    repositories:
      buildService: tkg/tap/tbs
      ootbSupplyChain: tkg/ootb
      testing: tkg/tap/pipeline
  artifactory:
     url: https://artifactory.$DOMAIN_NAME/artifactory/example-repo-local
  domains:
    gitlab: gitlab.$DOMAIN_NAME
    main: tap.$DOMAIN_NAME
    learningCenter: learningcenter.tap.$DOMAIN_NAME
    knative: apps.tap.$DOMAIN_NAME
  grype:
    dbUrl: https://$BUCKET_URL/grype/listing.json
#@ end
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tap-install-gitops
  namespace: tap-install-gitops
data:
  tap-config.yml: #@ yaml.encode(config())
