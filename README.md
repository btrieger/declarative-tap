# Deploying Tanzu Application Platform with GitOps

This project shows how to deploy
[Tanzu Application Platform](https://tanzu.vmware.com/application-platform) (TAP)
with a GitOps approach. Using this strategy, you can share the same configuration
across different installations
(one commit means one `tanzu package installed update` for every cluster),
while tracking any configuration updates with Git (easy rollbacks).

**Please note that this project is authored by a VMware employee under open source license terms.**

## What does it do?

This repo:
- Deploys TAP (full profile)
- Automatic installation of Tekton Pipelines and ScanPolicies to support the scanning_testing OOTB supply chain in all dev namespaces. See [here](additional/set-up-scanning-testing/). Including set up for maven in an airgapped environment by creating a settings xml service binding secret and java truststore with a private ca given to authenticate to artifactory with
- Creates a self signed ca issuer using the provided ca key and cert values provided by the user
- Creates a user-defined set of k8s namespaces (see [tap-values-full-input.yml](config-full/tap-values-full-input.yml) to define the namespaces.)
- Sets up those namespaces for TAP development, including installation of a Grype scanPolicy and a Tekton Pipeline
- Enables auto tls on cnrs for all workloads
- Auto integration of metadata store into tap-gui so that a read only access token does not need to be created after the fact.
- Auto set up of tls to the kubernetes tap-gui is running on
This repo includes:
- [Sample workload](additional/workloads/) to deploy after you've deployed TAP.
- Simple 'source-to-url' Supply chain to be applied afterward (since the default install deploys the scanning_testing supply chains). See [here](additional/cluster-supply-chains/).
- Some APIs added to the catalog for easy demos. See [here](gitops/tap-install-config.yml.tpl) for how to add/remove your own.

## How does it work?

This GitOps approach relies solely on [kapp-controller](https://carvel.dev/kapp-controller/)
and [ytt](https://carvel.dev/ytt/) to track Git commits and apply the configuration
to every cluster. These tools are part of the TAP prerequisites.

## How do I use it?
### Setup
1. Make sure [Cluster Essentials for VMware Tanzu is deployed to your cluster](https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-install-general.html#install-cluster-essentials-for-vmware-tanzu-2).

1. Create new file `tap-install-config.yml` in `gitops`, reusing content from [`tap-install-config.yml.tpl`](gitops/tap-install-config.yml.tpl).
Edit this file accordingly:
    * Change all $DOMAIN_NAME entries to the domain name of your lab instance
    * Change all $BUCKET_URL entries to the full bucket url used by your lab instance

1. Do the same with [`tap-install-secrets.yml.tpl`](gitops/tap-install-secrets.yml.tpl)
by creating `tap-install-secrets.yml`:
    - NOTE: This file is in the `.gitignore`. You'll want to make sure it's not committed (for the obvious reasons)

1.  Update the `tap-install.yml` with your repository if you've forked the project. Ultimately this is the "single" file that will be causing the declarative loop to occur.

2. If you're updating any of the values of the TAP install, ala the TAP version or the like, you'll want to commit them to your git repo.

3.  Remove any of the additional packages from the app in [`tap-install.yml`](gitops/tap-install.yml) should you not want them deployed. 




### Deploy 
You are now ready to apply the GitOps configuration. To do so change the path to your ca.crt:

```shell
kapp deploy --wait-check-interval 15s -a tap-install-gitops -f <(ytt -f gitops -f /path/to/ca.crt)
```

At this point, kapp-controller will monitor the Git repository: any updates
(commits) will be applied to your cluster, without having to run any commands.

Check that TAP is being deployed by running either command below:

```shell
tanzu package installed list -n tap-install

# OR

kctrl package installed list -n tap-install
```

Enjoy!

## Post Deployment
Now you can deploy the sample workload in additional/workloads after updating the gitlab url. 
## Contribute

Contributions are always welcome!

Feel free to open issues & send PR.

## License

Copyright &copy; 2022 [VMware, Inc. or its affiliates](https://vmware.com).

This project is licensed under the [Apache Software License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
