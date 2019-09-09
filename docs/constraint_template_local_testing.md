# Test config-validator constraints and templates locally without Forseti

**DISCLAIMER**: the file `data.json` used here containts all organization's assets metadata. Do NOT publish this information on a public repo. Use

This document is for users who wish to test constraint and
template on their organization metadata, from their system, before deploying to forseti. It both apply to existing templates and custom templates.

**Benefits**:

- Save time
- Reduce test complexity

**Acronyms**:

CAI - [Cloud Asset Inventory](https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/overview)  
GCP = Google Cloud Platform  
OPA - [Open Policy Agent](https://www.openpolicyagent.org/docs/latest)

**Table of contents**:

- [Prerequisites](Prerequisites)
- [Get organization's assets metadata in one `data.json` file](Get_organization's_assets_metadata_in_one_`data.json`_file)
- [Setup the test folder](Setup_the_test_folder)
- [Run test locally](Run_test_locally)
- [Contact info](Contact_info)

## Prerequisites

- [OPA is installed](https://www.openpolicyagent.org/docs/latest/get-started/#prerequisites) locally, and added to the PATH

## Get organization's assets metadata in one `data.json` file

- Copy organization's CAI `resource` dump and organization's CAI `iam_policy` dump in one folder
  - Depending on permissions available on the organization:
    - Donwload the 2 dumps files from Forseti CAI bucket
    - or use [CAI directly](https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/quickstart-cloud-asset-inventory) to export dumps
      - Key point: Ensure consistency by having the two dumps exported at the same time
- Run the python script `dump2json.py`
  - E.g. `python3 scripts/dump2json.py ----dump-folder-path dumpsFolderName`
  - Check the script's messages
  - `data.json` file is delivered in the dumps folder
  - `data.json` is an array of all organization's objects. Each object is a GCP asset. Each asset object contains a resource object and if applicable a iam_policy object too.
  - `ancestry_path` used in Forseti to specify where the constraint is to be applied has but computed and added.
  
Example  

```json
[  
  {  
    "name": "",  
    "asset_type": "",
    "resource": {
    },
    "iam_policy": {
    },
    "ancestry_path": ""
  }
]
```

## Setup the test folder

```bash
.                         # your config-validator repo root
├─ test                   # test folder, may be named differently
│  ├─ assets              # this folder is OPA's data.assets
│  │  └─ data.json        # the one json file from previous step
│  ├─ audit               # folder for rego files supporting test
│  │  └─ audit.rego       # policy module similar to forseti audit.go  
│  └─ constraints         # this folder is OPA's data.constraints
│     ├─ constraintname   # folder for the constraint to be tested
│     │   └─ anyname.yaml # constraint ymal file
│     └─ ...              # additional constraint folders if needed
└─ ...
```

The constraint yaml file to be tested is copied from `policies/constraints` to `test/constraints/constraintname/`  
To test multiple constraints at the same time, have multiple subfolders in `test/constraints/` each with one constraint yaml file.  

`audit.rego` is a similar rego policy module than the one embeeded in  [forseti-security/config-validator `audit.go`](https://github.com/forseti-security/config-validator/blob/master/pkg/gcv/cf/audit.go) enabling close local testing. It implements:

- assets filtering based on `ancestry_path`
- multiple constraints `deny` rule execution
- rich output to support troubleshooting

`opa run lib/ validator/ test/iamAuditLog_orgOnly_iap/`  

## Run test locally

- Launch [OPA REPL](https://www.openpolicyagent.org/docs/latest/get-started#goals) by executing `opa run lib/ validator/ test/`
- From OPA command line
  - `package validator.gcp.lib` this should produce no output
  - `audit` this execute the audit rego rule and outputs found non compliances
  - Execution time depens on assets number and constraints complexity

**Test output example**:

```json
[
  {
    "asset": "//cloudsql.googleapis.com/projects/my-project-id/instances/my-sal-instance-id",
    "constraint": "sqlMaintenanceWindow_orgFull",
    "constraint_config": {
      "apiVersion": "constraints.gatekeeper.sh/v1alpha1",
      "kind": "GCPSQLMaintenanceWindowConstraintV1",
      "metadata": {
        "annotations": {
          "description": "Check each sql instance has a maintenance window"
        },
        "name": "sqlMaintenanceWindow_orgFull"
      },
      "spec": {
        "match": {
          "exclude": [
            "organization/012345678901/folder/123456789012/folder/234567890123/folder/34567890123"
          ],
          "target": [
            "organization/012345678901"
          ]
        },
        "severity": "high"
      }
    },
    "violation": {
      "details": {
        "resource": "//cloudsql.googleapis.com/projects/my-project-id/instances/my-sal-instance-id"
      },
      "msg": "//cloudsql.googleapis.com/projects/my-project-id/instances/my-sal-instance-id missing maintenance window."
    }
  }
]
```

## Contact info

Questions or comments? Please contact validator-support@google.com.
