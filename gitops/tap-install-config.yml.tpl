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
     url: https://artifactory.tanzu-seal.io/artifactory/libs-release-local
  domains:
    gitlab: gitlab.tanzu-seal.io
    main: apps.tanzu.corp
    tapGui: tap-gui.apps.tanzu.corp
    learningCenter: learningcenter.apps.tanzu.corp
    knative: apps.tanzu.corp
  grype:
    dbUrl: https://tanzu-seal-61e9b6e0-a95d-42c2-9344-75d5585572b5.s3.us-east-2.amazonaws.com/grype/listing.json
#@ end
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tap-install-gitops
  namespace: tap-install-gitops
data:
  tap-config.yml: #@ yaml.encode(config())
