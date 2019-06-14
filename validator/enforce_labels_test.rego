#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPResourceLabelsV1

import data.validator.gcp.lib as lib

# Importing the test data 
import data.test.fixtures.enforce_labels.assets.projects as fixture_projects
import data.test.fixtures.enforce_labels.assets.k8s as fixture_k8s
import data.test.fixtures.enforce_labels.assets.buckets as fixture_buckets

import data.test.fixtures.enforce_labels.constraints as fixture_constraints

# Find all violations on our test cases
find_all_violations[violation] {
        resources := data.resources[_]
        constraint := data.test_constraints[_]
        issues := deny with input.asset as resources
                 with input.constraint as constraint
        violation := issues[_]
}

project_violations[violation] {
        constraints := [fixture_constraints.require_labels]
        violations := find_all_violations with data.resources as fixture_projects
                 with data.test_constraints as constraints
        violation := violations[_]
}

k8s_violations[violation] {
        constraints := [fixture_constraints.require_labels]
        violations := find_all_violations with data.resources as fixture_k8s
                 with data.test_constraints as constraints
        violation := violations[_]
}

bucket_violations[violation] {
        constraints := [fixture_constraints.require_labels]
        violations := find_all_violations with data.resources as fixture_buckets
                 with data.test_constraints as constraints
        violation := violations[_]
}

##### Testing for projects

# # Confirm two violations were found for projects
test_enforce_label_projects_violates_project_one {
        violations := project_violations
        count(violations) == 2
        violation := violations[_]
        is_string(violation.msg)
        is_object(violation.details)
}

# confirm which 2 projects are in violation
test_enforce_label_projects_violates_project_basic { 
        violations := project_violations
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/357960133769"
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/169463810970"
}

##### Testing for k8s


# # Confirm exactly 2 k8s pod violations were found for k8s
test_enforce_label_k8s_violates_project_two {
        violations := k8s_violations
        count(violations) == 2
        violation := violations[_]
        is_string(violation.msg)
        is_object(violation.details)
}

# confirm which 2 k8s pods are in violation
test_enforce_label_k8s_violates_project_basic { 
        violations := k8s_violations
    	violations[_].details.resource == "//container.googleapis.com/projects/project-without-labels/zones/us-west1-a/clusters/gke-data-dog-cluster/k8s/namespaces/kube-system/pods/fluentd-gcp-scaler-69d79984cb-xt9bg"
	violations[_].details.resource == "//container.googleapis.com/projects/project-with-missing-labels/zones/us-west1-a/clusters/gke-data-dog-cluster/k8s/namespaces/kube-system/pods/fluentd-gcp-scaler-69d79984cb-xt9bg"
}

##### Testing for buckets


# # Confirm exactly 2 bucket violations were found for k8s
test_enforce_label_bucket_violates_project_two {
        violations := bucket_violations
        count(violations) == 2
        violation := violations[_]
        is_string(violation.msg)
        is_object(violation.details)
}

# confirm which 2 bucket pods are in violation
test_enforce_label_bucket_violates_project_basic { 
        violations := bucket_violations
    	violations[_].details.resource == "//storage.googleapis.com/bucket-with-missing-labels"
	violations[_].details.resource == "//storage.googleapis.com/bucket-with-no-labels"
}