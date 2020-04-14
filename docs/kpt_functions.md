# Policy Library KPT Functions
This repo contains several kpt functions to manage documentation and make it easier to pull in policy for Config Validator.

These functions are meant to be run against this repo. Before running one of the below functions run `kpt get`:

```
kpt pkg get https://github.com/forseti-security/policy-library.git ./policy-library
cd ./policy-library
```

## Generate Docs
Generates markdown documentation for the templates and constraints in this repo.

### Run with Node
Generate the markdown docs.

```
kpt fn source ./samples/ ./policies/ | 
node bundler/dist/generate_docs_run.js -d sink_dir=./docs -d overwrite=true
```

## Get Policy Bundle
Filters the samples in this repo for a given [policy bundle](./index.md).

### Run with Node
Copy the `forseti-security` bundle to the constraints directory using Node.

```
kpt fn source ./samples/ |
node bundler/dist/get_policy_bundle_run.js -d bundle=bundles.validator.forsetisecurity.org/forseti-security -d sink_dir=./policies/constraints/ -d overwrite=true
```

### Build Docker image
Build a Docker image for this function.

```
make docker_build_kpt_bundle
```

### Run with Docker
Copy the `forseti-security` bundle to the constriants directory using Docker.

```
docker run -v ./samples/:/source gcr.io/kpt-dev/kpt fn source /source | 
docker run -i -u $(id -u) -v ./policies/constraints/:/sink gcr.io/config-validator/get-policy-bundle:latest -d bundle=bundles.validator.forsetisecurity.org/forseti-security -d sink_dir=/sink -d overwrite=true
```

## Tests
Tests use the Jasmine framework and can be run with npm or with docker.

### Run with Node
```
npm --prefix ./bundler test
```

### Run with Docker
```
make docker_kpt_test
```
