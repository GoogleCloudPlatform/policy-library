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
import data.test.fixtures.enforce_labels.assets.buckets as fixture_buckets
import data.test.fixtures.enforce_labels.assets.compute.disks as fixture_compute_disks
import data.test.fixtures.enforce_labels.assets.compute.images as fixture_compute_images
import data.test.fixtures.enforce_labels.assets.compute.instances as fixture_compute_instances
import data.test.fixtures.enforce_labels.assets.compute.snapshots as fixture_compute_snapshots
import data.test.fixtures.enforce_labels.assets.projects as fixture_projects

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

bucket_violations[violation] {
	constraints := [fixture_constraints.require_labels]
	violations := find_all_violations with data.resources as fixture_buckets
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_instance_violations[violation] {
	constraints := [fixture_constraints.require_labels]
	violations := find_all_violations with data.resources as fixture_compute_instances
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_image_violations[violation] {
	constraints := [fixture_constraints.require_labels]
	violations := find_all_violations with data.resources as fixture_compute_images
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_disk_violations[violation] {
	constraints := [fixture_constraints.require_labels]
	violations := find_all_violations with data.resources as fixture_compute_disks
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_snapshot_violations[violation] {
	constraints := [fixture_constraints.require_labels]
	violations := find_all_violations with data.resources as fixture_compute_snapshots
		 with data.test_constraints as constraints

	violation := violations[_]
}

##### Testing for projects

# # Confirm four violations were found for all projects
test_enforce_label_projects_violates_project_four {
	violations := project_violations
	count(violations) == 4
	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# confirm which 3 projects are in violation
test_enforce_label_projects_violates_project_basic {
	violations := project_violations
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/169463810970"
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/357960133769"
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/357960133899"
}

##### Testing for buckets

# # Confirm exactly 4 bucket violations were found
test_enforce_label_bucket_violates_project_four {
	violations := bucket_violations
	count(violations) == 4
	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# confirm which 3 buckets are in violation
test_enforce_label_bucket_violates_project_basic {
	violations := bucket_violations
	violations[_].details.resource == "//storage.googleapis.com/bucket-with-no-labels"
	violations[_].details.resource == "//storage.googleapis.com/bucket-with-label2-missing"
	violations[_].details.resource == "//storage.googleapis.com/bucket-with-label1-missing"
}

#### Testing for GCE resources

#### Testing for GCE instances
# # Confirm exactly 4 instance violations were found
test_enforce_label_compute_instance_violates_project_four {
	violations := compute_instance_violations
	count(violations) == 4
	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# confirm which 3 instances are in violation
test_enforce_label_compute_instance_violates_project_basic {
	violations := compute_instance_violations
	violations[_].details.resource == "//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-labels-8hz5"
	violations[_].details.resource == "//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-label1-8hz5"
	violations[_].details.resource == "//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-label2-8hz5"
}

#### Testing for GCE Images
# # Confirm exactly 4 images violations were found
test_enforce_label_compute_instance_violates_project_four {
	violations := compute_image_violations
	count(violations) == 4
	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# confirm which 3 images are in violation
test_enforce_label_compute_image_violates_project_basic {
	violations := compute_image_violations
	violations[_].details.resource == "//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-missing-label1"
	violations[_].details.resource == "//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-missing-label2"
	violations[_].details.resource == "//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-missing-label1"
}

#### Testing for GCE Disks
# # Confirm exactly 4 disk violations were found
test_enforce_label_compute_disk_violates_project_four {
	violations := compute_disk_violations
	count(violations) == 4
	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# confirm which 3 disks are in violation
test_enforce_label_compute_disk_violates_project_basic {
	violations := compute_disk_violations

	violations[_].details.resource == "//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-missing-labels"
	violations[_].details.resource == "//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-missing-label1"
	violations[_].details.resource == "//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-missing-label2"
}

#### Testing for GCE Snapshots
# # Confirm exactly 4 snapshot violations were found
test_enforce_label_compute_snapshot_violates_project_four {
	violations := compute_snapshot_violations
	count(violations) == 4
	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# confirm which 3 snapshots are in violation
test_enforce_label_compute_snapshot_violates_project_basic {
	violations := compute_snapshot_violations

	violations[_].details.resource == "//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-missing-labels"
	violations[_].details.resource == "//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-missing-label1"
	violations[_].details.resource == "//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-missing-label2"
}
