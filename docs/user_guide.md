## Config Validator | Setup & User Guide

### Go from setup to proof-of-concept in under 1 hour

## Overview

As your business shifts towards an infrastructure-as-code workflow, security and
cloud administrators are concerned about misconfigurations that may
cause security and governance violations.

Cloud Administrators need to be able to put up guardrails that follow security best
practices and help drive the environment towards programmatic security and governance while
enabling developers to go fast.

Config Validator allows your administrators to enforce constraints that validate
whether deployments can be provisioned while still enabling developers to move
quickly within these safe guardrails. Validator accomplishes this through a three
key components:

**One way to define constraints**

Constraints are defined so that they can work across an ecosystem of
pre-deployment and monitoring tools. These constraints live in your
organization's repository as the source of truth for your security and
governance requirements. You can obtain constraints from the
[Policy Library](#how-to-set-up-constraints-with-policy-library), or
[build your own constraints](#how-to-build-your-own-custom-constraint-templates).

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
on how to use Config Validator. By the end, you will have a proof-of-concept to experiment with and
to build your foundation upon.

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
kind: GCPExternalIpAccessConstraint
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

Your policy library repository specifies the constraints to be enforced. In order
for Forseti server to access it, you need to copy it over to Forseti server's
GCS bucket. Assuming you already have a local copy of your policy library
repository:

```
export FORSETI_BUCKET=`terraform output -module=forseti forseti-server-storage-bucket`
export POLICY_LIBRARY_PATH=path/to/local/policy-library
gsutil -m rsync -d -r ${POLICY_LIBRARY_PATH}/policies gs://${FORSETI_BUCKET}/policy-library/policies
gsutil -m rsync -d -r ${POLICY_LIBRARY_PATH}/lib gs://${FORSETI_BUCKET}/policy-library/lib
```

Example result:
![GCS Bucket Content](user_guide_bucket.png)

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

If you want to scale for large resource sets, you need to add more RAM to
your server**.** Upgrading the Forseti server VM to n1-standard-4 (15GB of RAM)
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
kind: GCPIAMAllowedPolicyMemberDomainsConstraint
metadata:
  name: service_accounts_only
spec:
  severity: high
  match:
    target: ["organizations/*"]
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
kind: GCPIAMAllowedPolicyMemberDomainsConstraint
metadata:
  name: service_accounts_only
spec:
  severity: high
  match:
    target: ["organizations/*"]
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

## How to build your own custom constraint templates

This section is only applicable to advanced users who wish to create custom
constraint templates. If the existing templates are sufficient, you can skip
this section.

#### Validate your constraint goals and target resources

Before beginning to develop your constraint template, you should write a
concrete definition of your goals in plain language. In writing this definition,
clearly define what resources you're looking to scan or analyze, and what
properties of those resources you plan to constrain.

For example:

```
The External IP Access Constraint will scan GCP VM instances and validate that the Access Config of their network interface does not include an external IP address.
```

#### Gather sample resource data

Before proceeding to develop your template, you should verify that Cloud Asset
Inventory
[supports](https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/overview#supported_resource_types)
the resources you want. Assuming it does, you should gather some sample data to
use in developing and testing your rule by creating resources of the appropriate
type and creating a CAI export of those resources (see
[CAI quickstart](https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/quickstart-cloud-asset-inventory)).
If the desired resource is not supported, please open a GitHub issue and/or
email validator-support@google.com.

For example, you might gather the following JSON export for external IP address
constraint (for brevity, most fields are omitted). In the same data below, the
presence of the `externalIp` field indicates that an external IP address is
assigned to the VM.

```
[
  {
    "name": "//compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/vm",
    "asset_type": "google.compute.Instance",
    "resource": {
      "version": "v1",
      "discovery_document_uri": "https://www.googleapis.com/discovery/v1/apis/compute/v1/rest",
      "discovery_name": "Instance",
      "parent": "//cloudresourcemanager.googleapis.com/projects/68478495408",
      "data": {
        "name": "vm-external-ip",
        "networkInterface": [
          {
            "accessConfig": [
              {
                "externalIp": "35.196.151.107",
                "name": "external-nat",
                "networkTier": "PREMIUM",
                "type": "ONE_TO_ONE_NAT"
              }
            ],
            "fingerprint": "FKYLBaTiCF0=",
            "ipAddress": "10.142.0.2",
            "name": "nic0",
            "network": "https://www.googleapis.com/compute/v1/projects/test-project/global/networks/default",
            "subnetwork": "https://www.googleapis.com/compute/v1/projects/test-project/regions/us-east1/subnetworks/default"
          }
        ],
      }
    }
  },
]
```

#### Write Rego rule for constraint template

In order to develop a constraint template, you must develop a Rego rule to back
it. Before you begin, read about
[how to write policies](https://www.openpolicyagent.org/docs/how-do-i-write-policies.html)
using Rego and Open Policy Agent.

To store a rule for your constraint template, create a new Rego file (for
example, <code><em>vm_external_ip.rego</em></code>). This file should include a
single <code><em>deny</em></code> rule which returns violations by evaluating
whether a given <code><em>input.asset</em></code> violates the constraint
provided in <code><em>input.constraint</em></code>.

As you develop the Rego rule, keep these principles in mind:

*   Logic can be externalized into additional rules and functions which should
    be defined below the deny rule in a utilities section.
*   If your rule only applies to particular resource types, you should check
    that the given <code><em>input.asset</em></code> is of the required type
    early on. (for example, <code><em>input.asset.asset_type ==
    "google.compute.Instance"</em></code>).
*   If your rule requires input parameters, they will be present under
    <code>input.constraint</code>. You can retrieve it using the library
    function <code>get_constraint_params</code> in the
    <code>data.validator.gcp.lib</code> package.
*   Comments should be included for any complicated logic and all helper
    functions and rules should have a comment explaining their intent.
*   Equality comparison should be done using <code><em>==</em></code> to
    differentiate it from assignment.
*   A violation is generated only when the rule body evaluates to true. In other
    words, you should look for the negative condition.
*   There are helpful functions available in the GCP library which you can
    import into your rule. For example, <code><em>import data.validator.gcp.lib
    as lib</em></code>.

For example, this rule checks whether a VM with external IP address should be
exempted (whitelist) or treated as a violation (blacklist):

```
package validator.gcp.vm_external_ip
import data.validator.gcp.lib as lib

deny[{
        "msg": message,
        "details": metadata,
}] {
        constraint := input.constraint
        lib.get_constraint_params(constraint, params)
        asset := input.asset
        asset.asset_type == "google.compute.Instance"
        # Find network access config block w/ external IP
        instance := asset.resource.data
        access_config := instance.networkInterface[_].accessConfig
        external_ip := access_config[_].externalIp
        # Check if instance is in blacklist/whitelist
        target_instances := params.instances
        matches := {asset.name} & cast_set(target_instances)
        target_instance_match_count(params.mode, desired_count)
        count(matches) == desired_count
        message := sprintf("%v is not allowed to have an external IP.", [asset.name])
        metadata := {"external_ip": external_ip}
}

# Determine the overlap between instances under test and constraint
# By default (whitelist), we violate if there isn't overlap
target_instance_match_count(mode) = 0 {
        mode != "blacklist"
}
target_instance_match_count(mode) = 1 {
        mode == "blacklist"
}
```

#### Write constraint and resource fixtures for your constraint template

To test your rule, create fixtures of the expected resources and constraints
leveraging your rule. To implement your test cases, gather resource fixtures
from CAI and place them in a
<code><em>test/fixtures/resources/<resource_type>/data.json</em></code> file.
You can also write a constraint fixture using your constraint template and place
it in
<code><em>test/fixtures/constraints/<constraint_name/data.yaml</em></code>.

For example, here is a sample constraint used for external IP rule:

```
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPExternalIpAccessConstraint
metadata:
  name: forbid-external-ip-whitelist
spec:
  severity: high
  match:
    target: ["organization/*"]
  parameters:
    mode: "whitelist"
    instances:
      - //compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/vm-external-ip
```

The rule above says that the external IP constraint applies to all
organizations, but the GCE instance `vm-external-ip` under `test-project` in
`us-east1-b` is exempt.

#### Write Rego tests for your rule

As you develop your constraint template, implement test cases that ensure your
logic doesn't break over time. Open Policy Agent allows you to
[implement simple tests](https://www.openpolicyagent.org/docs/how-do-i-test-policies.html)
by prefixing rules with `test_`.

Using the fixtures you have gathered, write tests in a Rego file named after
your rule. For example, <code><em>vm_external_ip_test.rego</em></code>. Make
sure to place this Rego file in the same package as your rule with the
<code>package</code> definition. One useful pattern is to write a rule which
gathers all violations for your test cases and additional <code>test_</code>
rules which verify those violations.

For example, here are the tests for the above external IP constraint:

```
package validator.gcp.vm_external_ip

import data.test.fixtures.assets.compute_instances as fixture_instances
import data.test.fixtures.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
        instance := data.instances[_]
        constraint := data.test_constraints[_]
        issues := deny with input.asset as instance
                 with input.constraint as constraint
        total_issues := count(issues)
        violation := issues[_]
}

whitelist_violations[violation] {
        constraints := [fixture_constraints.forbid_external_ip_whitelist]
        found_violations := find_violations with data.instances as fixture_instances
                 with data.test_constraints as constraints
        violation := found_violations[_]
}

# Confirm only a single violation was found (whitelist constraint)
test_external_whitelist_ip_violates_one {
        found_violations := whitelist_violations
        count(found_violations) = 1
        violation := found_violations[_]
        resource_name := "//compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/vm-external-ip"
        is_string(violation.msg)
        is_object(violation.details)
}

```

#### Create constraint template YAML definition

Once you have a working Rego rule, you are ready to package it into a constraint
template. You can do this by writing a YAML file which defines the expected
parameters and logic for constraints. Create this file from the template, and
then input the contents of your Rego rule.

This example shows the external IP constraint template, with the italicized
portions changing for your template:

```
apiVersion: templates.gatekeeper.sh/v1alpha1
kind: ConstraintTemplate
metadata:
  name: gcp-external-ip-access
  annotations:
    # Example of tying a template to a CIS benchmark
    benchmark: CIS11_5.03
spec:
  crd:
    spec:
      names:
        kind: GCPExternalIpAccessConstraint
        listKind: GCPExternalIpAccessConstraintList
        plural: GCPExternalIpAccessConstraints
        singular: GCPExternalIpAccessConstraint
      validation:
        openAPIV3Schema:
          properties:
            mode:
              type: string
              enum: [blacklist, whitelist]
            instances:
              type: array
              items: string
  targets:
   validation.gcp.forsetisecurity.org:
      rego: |
            #INLINE("validator/vm_external_ip.rego")
            #ENDINLINE
```

The Rego rule is supposed to be inlined in the YAML file. To do that, run `make
build`. That will format the rego rules and inline them in the YAML files under
the `#INLINE` directive.

## Contact Info

Questions or comments? Please contact validator-support@google.com.
