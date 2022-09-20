#@ load("@ytt:yaml", "yaml")
---
#@ def config():
tap:
  credentials:
    ca_cert_key: |
       KEYDATA
       HERE
    #! Pick one registry for downloading images: Tanzu Network or Pivotal Network
    #! (use tanzuNet as key).
    tanzuNet:
      username: INSERT-TANZUNET-USERNAME
      password: INSERT-TANZUNET-PASSWORD
    tanzuNet-pivnet:
      host: registry.pivotal.io
      username: INSERT-PIVNET-USERNAME
      password: INSERT-PIVNET-PASSWORD
    artifactory:
      username: INSERT-ARTIFACTORY-USERNAME
      password: INSERT-ARTIFACTORY-PASSWORD
    javatrust:
      password: INSERT-TRUSTSTORE-PASSWORD
    registry:
      username: INSERT-REGISTRY-USERNAME
      password: INSERT-REGISTRY-PASSWORD
    #! Remove suffix "-disabled" to enable GitHub integration:
    #! - set clientId and clientSecret to enable authentication,
    #! - set token to download resources from GitHub (such as Backstage catalogs).
    github-disabled:
      clientId: INSERT-GITHUB-CLIENTID
      clientSecret: INSERT-GITHUB-CLIENTSECRET
      token: INSERT-GITHUB-TOKEN
    #! Remove suffix "-disabled" to enable Backstage persistence.
    backstage-disabled:
      database:
        client: pg
        host: INSERT-DB-HOST
        port: 5432
        username: INSERT-DB-USERNAME
        password: INSERT-DB-PASSWORD

    #! ---------- Additional configuration beyond basic TAP installation ----------

    #! Remove suffix "-disabled" to enable a provider for External DNS.
    external_dns:
      aws-disabled:
        region: eu-central-1
        credentials: #! Note internal VMware users: CloudGate credentials will not have the necessary permissions to work
          accessKey: 
          secretKey: 
        route_fifty_three_zone_id:

      cloudflare-disabled:
        credentials:
          apiToken:

    #! Uncomment any block to use it.

    #! Enable Okta OIDC auth for tap-gui
    #! ref: https://backstage.io/docs/auth/okta/provider
    #!okta:
    #!  clientId: INSERT-ID
    #!  clientSecret: INSERT-SECRET
    #!  audience:  INSERT-AUDIENCE (example: https://dev-123456.okta.com)

    #! Allow tap-gui to access the security metadata store.
    #! ref: https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-scst-store-create-service-account-access-token.html#ro-serv-accts
    #! Uncomment the below after you enable cve in tap-gui
#@ end
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-install-gitops-github
  namespace: tap-install-gitops
stringData:
  username: github
  password: INSERT-GITHUB-TOKEN
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-install-gitops
  namespace: tap-install-gitops
stringData:
  tap-secrets.yml: #@ yaml.encode(config())
