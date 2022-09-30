#@ load("@ytt:yaml", "yaml")
---
#@ def config():
tap:
  #! Set Backstage catalogs to include by default.
  version: "1.2.1"
  tbs:
    version: "1.6.0"
  catalogs:
  - https://github.com/backstage/backstage/blob/master/packages/catalog-model/examples/all.yaml
  devNamespaces: 
    - dev-tap
  ca_cert_data:  #@ data.read("ca.crt")
  registry:
    host: harbor.tanzu-seal.io
    repositories:
      buildService: tkg/tap/tbs
      ootbSupplyChain: tkg/ootb
      testing: tkg/tap/pipeline
  artifactory:
     url: https://artifactory.YOUR DOMAIN/artifactory/example-repo-local
  domains:
    gitlab: gitlab.YOUR DOMAIN
    main: tap.YOUR DOMAIN
    learningCenter: learningcenter.tap.YOUR DOMAIN
    knative: apps.tap.YOUR DOMAIN
  grype:
    dbUrl: https://YOUR S3 BUCKET URL/grype/listing.json
#@ end
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tap-install-gitops
  namespace: tap-install-gitops
data:
  tap-config.yml: #@ yaml.encode(config())
