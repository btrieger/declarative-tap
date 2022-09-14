Setting up dev namespaces to use the scannin_testing pipeline.

1. Edit `values.yml` to include the names of the namespaces (NOTE: the namespaces need to already exist).

1. Deploy with:
```sh
ytt -f . | kapp deploy --wait-check-interval 10s -a scanning-testing-deps  -f- --yes
```