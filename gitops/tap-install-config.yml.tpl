#@ load("@ytt:yaml", "yaml")
---
#@ def config():
tap:
  #! Set Backstage catalogs to include by default.
  catalogs:
  - https://github.com/backstage/backstage/blob/master/packages/catalog-model/examples/all.yaml
  devNamespaces: 
    - dev-tap
  registry:
    host: registry.tanzu.corp
    repositories:
      buildService: tanzu/tanzu-build-service
      ootbSupplyChain: tanzu/tanzu-supply-chain
      testing: tanzu/pipeline
  artifactory:
     url: https://artifactory.YOUR DOMAIN/artifactory/libs-release-local
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
