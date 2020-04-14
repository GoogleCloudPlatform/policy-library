# Policy Library KPT Functions
This repo contains several kpt functions to help manage.

These functions are meant to be run against this repo. Before running one of the below functions run `kpt get`:

```
kpt pkg get https://github.com/forseti-security/policy-library.git ./policy-library
cd ./policy-library
```

## Generate Docs
Generates markdown documentation for the templates and constraints in this repo.

## Get Policy Bundle
Filters the samples in this repo for a given [policy bundle](./index.md).

### Run with Node
Copy the `forseti-security` bundle to the constraints directory using Node.
```
kpt fn source ./samples/ | \
node bundler/dist/get_policy_bundle_run.js -d bundle=bundles.validator.forsetisecurity.org/forseti-security -d sink_dir=./policies/constraints/ -d overwrite=true
```

### Run with Docker
Copy the `forseti-security` bundle to the constriants directory using Docker.
```
kpt fn source ./samples/ | 
docker run -i -u $(id -u) -v ./policies/constraints/:/sink gcr.io/config-validator/bundler -d bundle=bundles.validator.forsetisecurity.org/forseti-security -d sink_dir=/sink -d overwrite=true
```