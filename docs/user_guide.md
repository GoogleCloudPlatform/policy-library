## Config Validator | Setup & User Guide

### Go from setup to proof-of-concept in under 1 hour

**Table of Contents**

* [Overview](#overview)
* [How to set up constraints with Policy Library](#how-to-set-up-constraints-with-policy-library)
  * [Get started with the Policy Library repository](#get-started-with-the-policy-library-repository)
  * [Instantiate constraints](#instantiate-constraints)
* [How to use Terraform Validator](#how-to-use-terraform-validator)
  * [Install Terraform Validator](#install-terraform-validator)
  * [For local development environments](#for-local-development-environments)
  * [For Production Environments](#for-production-environments)
* [How to Use Forseti Config Validator](#how-to-use-forseti-config-validator)
  * [Install Forseti](#install-forseti)
  * [Copy over policy library repository](#copy-over-policy-library-repository)
  * [How to change the run frequency of Forseti](#how-to-change-the-run-frequency-of-forseti)
  * [How to handle scaling for large resource sets](#how-to-handle-scaling-for-large-resource-sets)
  * [How to connect violation results with Cloud Security Command Center (CSCC)](#how-to-connect-violation-results-with-cloud-security-command-center-cscc)
* [End to end workflow with sample constraint](#end-to-end-workflow-with-sample-constraint)
* [Contact Info](#contact-info)

## Overview

As your business shifts towards an infrastructure-as-code workflow, security and
cloud administrators are concerned about misconfigurations that may cause
security and governance violations.

Cloud Administrators need to be able to put up guardrails that follow security
best practices and help drive the environment towards programmatic security and
governance while enabling developers to go fast.

Config Validator allows your administrators to enforce constraints that validate
whether deployments can be provisioned while still enabling developers to move
quickly within these safe guardrails. Validator accomplishes this through a
three key components:

**One way to define constraints**

Constraints are defined so that they can work across an ecosystem of
pre-deployment and monitoring tools. These constraints live in your
organization's repository as the source of truth for your security and
governance requirements. You can obtain constraints from the
[Policy Library](#how-to-set-up-constraints-with-policy-library), or
[build your own constraint templates](constraint_template_authoring.md).

**Pre-deployment check**

Check for constraint violations during pre-deployment and provide warnings or
halt invalid deployments before they reach production. The pre-deployment logic
that Config Validator uses will be built into a number of deployment tools. For
details, [check out Terraform Validator](#how-to-use-terraform-validator).

**Ongoing monitoring**

Frequently scan the platform for constraint violations and send notifications
when a violation is found. The monitoring logic that Config Validator uses will
be built into a number of monitoring tools. For details,
[check out Forseti Validator](#how-to-use-forseti-config-validator).

The following guide will walk you through initial setup steps and instructions
on how to use Config Validator. By the end, you will have a proof-of-concept to
experiment with and to build your foundation upon.

## How to set up constraints with Policy Library

### Get started with the Policy Library repository

The Policy Library repository contains the following directories:

*   `policies`
    *   `constraints`: This is initially empty. You should place your constraint
        files here.
    *   `templates`: This directory contains pre-defined constraint templates.
*   `validator`: This directory contains the `.rego` files and their associated
    unit tests. You do not need to touch this directory unless you intend to
    modify existing constraint templates or create new ones. Running `make
    build` will inline the Rego content in the corresponding constraint template
    files.

Google provides a sample repository with a set of pre-defined constraint
templates. You will first clone the repository:

```
git clone https://github.com/forseti-security/policy-library.git
```

Then you need to examine the available constraint templates inside the
`templates` directory. Pick the constraint templates that you wish to use,
create constraint YAML files correspondings to those templates, and place them
under `policies/constraints`. Commit the newly created constraint files to
**your** Git repository. For example, assuming you have created Git repository
named "policy-library" under your GitHub account, you can use the following
commands to perform the initial commit:

```
export GIT_REPO_ADDR="git@github.com:${YOUR_GITHUB_USERNAME}/policy-library.git"
cd policy-library
# Add new constraints...
git add .
git commit -m "Initial commit of policy library"
git remote add policy-library "${GIT_REPO_ADDR}"
git push -u policy-library master
```

### Instantiate constraints

The constraint template library only contains templates. Templates specify the
constraint logic, and you must create constraints based on those templates in
order to enforce them. Constraint parameters are defined as YAML files in the
following format:

```
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: # place constraint template kind here
metadata:
  name: # place constraint name here
spec:
  severity: # low, medium, or high
  match:
    target: [] # put the constraint application target here
    exclude: [] # optional, default is no exclusions
  parameters: # put the parameters defined in constraint template here
```

The <code><em>target</em></code> field is specified in a path-like format. It
specifies where in the GCP resources hierarchy the constraint is to be applied.
For example:

<table>
  <tr>
   <td>Target
   </td>
   <td>Description
   </td>
  </tr>
  <tr>
   <td>organization/*
   </td>
   <td>All organizations
   </td>
  </tr>
  <tr>
   <td>organization/123/*
   </td>
   <td>Everything in organization 123
   </td>
  </tr>
  <tr>
   <td>organization/123/folder/*
   </td>
   <td>Everything in organization 123 that is under a folder
   </td>
  </tr>
  <tr>
   <td>organization/123/folder/456
   </td>
   <td>Everything in folder 456 in organization 123
   </td>
  </tr>
  <tr>
   <td>organization/123/folder/456/project/789
   </td>
   <td>Everything in project 789 in folder 456 in organization 123
   </td>
  </tr>
</table>

The <code><em>exclude</em></code> field follows the same pattern and has
precedence over the <code><em>target</em></code> field. If a resource is in
both, it will be excluded.

The schema of the <code><em>parameters</em></code> field is defined in the
constraint template, using the
[OpenAPI V3](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schemaObject)
schema. This is the same validation schema in Kubernetes's custom resource
definition. Every template contains a <code><em>validation</em></code> section
that looks like the following:

```
validation:
  openAPIV3Schema:
    properties:
      mode:
        type: string
      instances:
        type: array
        items: string
```

According to the template above, the parameter field in the constraint file
should contain a string named `mode` and a string array named
<code><em>instances</em></code>. For example:

```
parameters:
  mode: whitelist
  instances:
    - //compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/one
    - //compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/two
```

These parameters specify that two VM instances may have external IP addresses.
The are exempt from the constraint since they are whitelisted.

Here is a complete example of a sample external IP address constraint file:

```
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPExternalIpAccessConstraintV1
metadata:
  name: forbid-external-ip-whitelist
spec:
  severity: high
  match:
    target: ["organization/*"]
  parameters:
    mode: "whitelist"
    instances:
    - //compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/one
    - //compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/two
```

## How to use Terraform Validator

### Install Terraform Validator

The released binaries are available under the `gs://terraform-validator` Google
Cloud Storage bucket for Linux, Windows, and Mac. They are organized by release
date, for example:

```
$ gsutil ls -r gs://terraform-validator/releases
...
gs://terraform-validator/releases/2019-04-04/terraform-validator-darwin-amd64
gs://terraform-validator/releases/2019-04-04/terraform-validator-linux-amd64
gs://terraform-validator/releases/2019-04-04/terraform-validator-windows-amd64
```

To download the binary, you need to
[install](https://cloud.google.com/storage/docs/gsutil_install#install) the
`gsutil` tool first. The following command downloads the Linux version of
Terraform Validator from 2019-04-04 release to your local directory:

```
gsutil cp gs://terraform-validator/releases/2019-04-04/terraform-validator-linux-amd64 .
chmod 755 terraform-validator-linux-amd64
```

### For local development environments

Currently only Terraform v0.11 is supported.
These instructions assume you have forked a branch and is working locally.

Generate a Terraform plan for the current environment by running:

```
terraform plan -out=tfplan.tfplan
```

To validate the Terraform plan based on the constraints specified under your
local policy library repository, run:

```
terraform-validator-linux-amd64 validate tfplan.tfplan --policy-path=${POLICY_PATH}
```

The policy-path flag is set to the local clone of your Git repository that
contains the constraints and templates. This is described in the
["How to set up constraints with Policy Library"](#how-to-set-up-constraints-with-policy-library)
section.

Terraform Validator also accepts an optional --project flag which is set to the
Terraform Google provider project. See the
[provider docs](https://www.terraform.io/docs/providers/google/index.html) for
more info. If it is not set, Terraform Validator will attempt to parse the
provider project from the provider configuration.

If violations are found, a list will be returned of the affected resources and a
brief message about the violations:

```
Found Violations:

Constraint iam_domain_restriction on resource //cloudresourcemanager.googleapis.com/projects/299388503561: IAM policy for //cloudresourcemanager.googleapis.com/projects/299388503561 contains member from unexpected domain: user:foo@example.com

Constraint iam_domain_restriction on resource //cloudresourcemanager.googleapis.com/projects/299388503561: IAM policy for //cloudresourcemanager.googleapis.com/projects/299388503561 contains member from unexpected domain: group:bar@example.com
```

If all constraints are validated, the command will return "`No violations
found`." You can then apply a plan locally on a development environment:

```
terraform apply
```

### For Production Environments

These instructions assume that the developer has merged their local branch back
with master. We want to make sure the master deployment into production is
validated.

In your continuous integration (CI) tool, you should install Terraform
validator. Then you can add a step to any workflow which will validate a
Terraform plan and reject it if violations are found. Terraform validator will
return a `2` exit code if violations are found or `0` if no violations were
found. Therefore, you should configure your CI to only proceed to the next step
(for example, `terraform apply`) or merge if the validator exits successfully.

## How to Use Forseti Config Validator

### Install Forseti

Follow the standard installation process. This guide assumes Terraform is used
to install Forseti, and Forseti can be installed via its own
[installer](https://forsetisecurity.org/docs/v2.2/setup/install.html) or
[Cloud Foundation Toolkit](https://github.com/terraform-google-modules/terraform-google-forseti)
as well.

If you haven't already, the first step is to
[Install](https://learn.hashicorp.com/terraform/getting-started/install.html)
Terraform. Then use the
[terraform-google-forseti](https://github.com/terraform-google-modules/terraform-google-forseti)
module to install Forseti. Here is a sample main.tf file modeled mostly from the
"[simple example](https://github.com/terraform-google-modules/terraform-google-forseti/tree/master/examples/simple_example)":

```
module "forseti" {
      source  = "terraform-google-modules/forseti/google"
      version = "~> 1.4"


      domain             = "yourdomain.com"
      project_id         = "your-forseti-project-id-here"
      org_id             = "your-org-id-here"
      …
      config_validator_enabled = true
    }
```

The one important additions is the `config_validator_enabled` field. It is not
enabled by default; therefore you need to explicitly enable it.

### Copy over policy library repository

Your policy library repository specifies the constraints to be enforced. In
order for Forseti server to access it, you need to copy it over to Forseti
server's GCS bucket. Assuming you already have a local copy of your policy
library repository:

```
export FORSETI_BUCKET=`terraform output -module=forseti forseti-server-storage-bucket`
export POLICY_LIBRARY_PATH=path/to/local/policy-library
gsutil -m rsync -d -r ${POLICY_LIBRARY_PATH}/policies gs://${FORSETI_BUCKET}/policy-library/policies
gsutil -m rsync -d -r ${POLICY_LIBRARY_PATH}/lib gs://${FORSETI_BUCKET}/policy-library/lib
```

Example result: ![GCS Bucket Content](user_guide_bucket.png)

After this is done, Forseti will pick up the new policy library content in the
next scanner run.

### How to change the run frequency of Forseti

The Forseti inventory and scanning processes is scheduled to run by a cron job.
To update the run frequency of this cron job, you need to understand
[the time format of a cron job](https://crontab.guru/). After you have your
desired time format, you can update the run frequency by following the steps
below:

In main.tf, under module "forseti" include **forseti_run_frequency** and set the
value to your desired time format. For example, <code><em>"0 */2 * *
*"</em></code>.

```
   module "forseti" {
      ...
      forseti_run_frequency = "0 */2 * * *"
    }
```

Run _terraform plan_ command to see the change and _terraform apply_ command to
apply the change.

### How to handle scaling for large resource sets

If you want to scale for large resource sets, you need to add more RAM to your
server**.** Upgrading the Forseti server VM to n1-standard-4 (15GB of RAM)
should be able to handle most use cases. Depending on the state and size of your
data, this may trigger a large number of violations. Currently GRPC has a
payload size limitation of 4MB. If a scanner run results in > 4MB of violation
data to be generated, that will result in an error.

In the future, we will consider the following changes:

*   Use streaming GRPC or paging the violation results.
*   Split the dataset into multiple chunks and process them separately.

### How to connect violation results with Cloud Security Command Center (CSCC)

Forseti has a plugin with Cloud Security Command Center (CSCC) which allows you
to receive PubSubs with CSCC. By subscribing to the PubSub feed, you have
control of remediating manually or programmatically with Cloud Functions.

To connect to CSCC, you need the following roles:

*   Organization Admin
*   Security Center Admin
*   Service Account Admin

Follow step 1-4 listed
[here](https://forsetisecurity.org/docs/latest/configure/notifier/index.html#setup)
to set CSCC up for Forseti.

Once you have CSCC set up, you can navigate to the CSCC settings page from the
Google Cloud Platform (GCP) UI. For example:
![CSCC Integration](user_guide_cscc.png)

In **main.tf**, under module "forseti", include _cscc_source_id_ and
_cscc_violations_enabled_. Set _cscc_source_id_ to the source ID generated by
CSCC for Forseti, and _cscc_violations_enabled** **_to** _true_**.

```
   module "forseti" {
      …..
      cscc_source_id = "YOUR_CSCC_SOURCE_ID_FOR_FORSETI"
      cscc_violations_enabled = true
    }
```

Run _terraform plan_ command to see the change and _terraform apply_ command to
apply the change.

## End to end workflow with sample constraint

In this section, you will apply a constraint that enforces IAM policy member
domain restriction using [Cloud Shell](https://cloud.google.com/shell/).

First click on this
[link](https://console.cloud.google.com/cloudshell/open?cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest&cloudshell_git_repo=https://github.com/forseti-security/policy-library.git)
to open a new Cloud Shell session. The Cloud Shell session has Terraform
pre-installed and the Policy Library repository cloned. Once you have the
session open, the next step is to copy over the sample IAM domain restriction
constraint:

```
cp policy-library/samples/iam_service_accounts_only.yaml policy-library/policies/constraints
```

Let's take a look at this constraint:

```
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedPolicyMemberDomainsConstraintV1
metadata:
  name: service_accounts_only
spec:
  severity: high
  match:
    target: ["organization/*"]
  parameters:
    domains:
      - gserviceaccount.com
```

It specifies that only members from gserviceaccount.com domain can be present in
an IAM policy. To verify that it works, let's attempt to create a project.
Create the following Terraform `main.tf` file:

```
provider "google" {
  version = "~> 1.20"
  project = "your-terraform-provider-project"
}

resource "random_id" "proj" {
  byte_length = 8
}

resource "google_project" "sample_project" {
  project_id      = "validator-${random_id.proj.hex}"
  name            = "config validator test project"
}

resource "google_project_iam_binding" "sample_iam_binding" {
  project = "${google_project.sample_project.project_id}"
  role    = "roles/owner"

  members = [
    "user:your-email@your-domain"
  ]
}

```

Make sure to specify your Terraform
[provider project](https://www.terraform.io/docs/providers/google/getting_started.html)
and email address. Then initialize Terraform and generate a Terraform plan:

```
terraform init
terraform plan -out=test.tfplan
```

Since your email address is in the IAM policy binding, the plan should result in
a violation. Let's try this out:

```
gsutil cp gs://terraform-validator/releases/2019-03-28/terraform-validator-linux-amd64 .
chmod 755 terraform-validator-linux-amd64
./terraform-validator-linux-amd64 validate test.tfplan --policy-path=policy-library
```

The Terraform validator should return a violation. As a test, you can relax the
constraint to make the violation go away. Edit the
`policy-library/policies/constraints/iam_service_accounts_only.yaml` file and
append your email domain to the domains whitelist:

```
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedPolicyMemberDomainsConstraintV1
metadata:
  name: service_accounts_only
spec:
  severity: high
  match:
    target: ["organization/*"]
  parameters:
    domains:
      - gserviceaccount.com
      - your-domain-here
```

Then run Terraform plan and validate the output again:

```
terraform plan -out=test.tfplan
./terraform-validator-linux-amd64 validate test.tfplan --policy-path=policy-library
```

The command above should result in no violations found.

## Contact Info

Questions or comments? Please contact validator-support@google.com.
