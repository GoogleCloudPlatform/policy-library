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

package templates.gcp.GCPEnforceLabelConstraintV1

import data.validator.gcp.lib as lib

# Importing the test data 

import data.test.fixtures.enforce_labels.assets.bigtable as fixture_bigtable
import data.test.fixtures.enforce_labels.assets.buckets as fixture_buckets
import data.test.fixtures.enforce_labels.assets.cloudsql as fixture_cloudsql
import data.test.fixtures.enforce_labels.assets.compute.disks as fixture_compute_disks
import data.test.fixtures.enforce_labels.assets.compute.images as fixture_compute_images
import data.test.fixtures.enforce_labels.assets.compute.instances as fixture_compute_instances
import data.test.fixtures.enforce_labels.assets.compute.snapshots as fixture_compute_snapshots
import data.test.fixtures.enforce_labels.assets.dataproc.clusters as fixture_dataproc_clusters
import data.test.fixtures.enforce_labels.assets.dataproc.jobs as fixture_dataproc_jobs
import data.test.fixtures.enforce_labels.assets.projects as fixture_projects

# Importing the test constraint
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
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_projects
		 with data.test_constraints as constraints

	violation := violations[_]
}

bucket_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_buckets
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_instance_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_compute_instances
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_image_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_compute_images
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_disk_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_compute_disks
		 with data.test_constraints as constraints

	violation := violations[_]
}

compute_snapshot_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_compute_snapshots
		 with data.test_constraints as constraints

	violation := violations[_]
}

bigtable_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_bigtable
		 with data.test_constraints as constraints

	violation := violations[_]
}

cloudsql_violations[violation] {
	constraints := [fixture_constraints]
	violations := find_all_violations with data.resources as fixture_cloudsql
		 with data.test_constraints as constraints

	violation := violations[_]
}

dataproc_violations[violation] {
	constraints := [fixture_constraints]

	job_violations := find_all_violations with data.resources as fixture_dataproc_jobs
		 with data.test_constraints as constraints

	cluster_violations := find_all_violations with data.resources as fixture_dataproc_clusters
		 with data.test_constraints as constraints

	violations := job_violations | cluster_violations

	violation := violations[_]
}

##### Testing for projects

# Confirm six violations were found for all projects
# 4 projects have violations - 2 of which have 2 violations (one has 2 labels missing, 
# the other has 2 labels with invalid values) 
# confirm which 4 projects are in violation
test_enforce_label_projects_violations {
	violations := project_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//cloudresourcemanager.googleapis.com/projects/169463810970",
		"//cloudresourcemanager.googleapis.com/projects/357960133769",
		"//cloudresourcemanager.googleapis.com/projects/357960133899",
		"//cloudresourcemanager.googleapis.com/projects/357960133233",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

##### Testing for buckets

# Confirm exactly 6 bucket violations were found
# 4 buckets have violations - 2 of which have 2 violations (one has 2 labels missing,
# the other has 2 labels with invalid values)
# confirm which 4 buckets are in violation
test_enforce_label_bucket_violations {
	violations := bucket_violations

	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//storage.googleapis.com/bucket-with-no-labels",
		"//storage.googleapis.com/bucket-with-label2-missing",
		"//storage.googleapis.com/bucket-with-label1-missing",
		"//storage.googleapis.com/bucket-with-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

##### Testing for GCE resources

#### Testing for GCE instances

# Confirm exactly 6 instance violations were found
# 4 instances have violations - 2 of which have 2 violations (one has 2 labels missing, the other has 2 labels with invalid values)
# confirm which 4 instances are in violation
test_enforce_label_compute_instance_violations {
	violations := compute_instance_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-labels-8hz5",
		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-label1-8hz5",
		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-missing-label2-8hz5",
		"//compute.googleapis.com/projects/vpc-sc-pub-sub-billing-alerts/zones/us-central1-b/instances/invalid-instance-with-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#### Testing for GCE Images
# Confirm exactly 4 images violations were found
# 4 images have violations - 2 of which have 2 violations (one has 2 labels missing,
# the other has 2 labels with invalid values)
# confirm which 4 images are in violation
test_enforce_label_compute_image_violations {
	violations := compute_image_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-missing-labels",
		"//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-missing-label2",
		"//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-missing-label1",
		"//compute.googleapis.com/projects/my-own-project/global/images/test-invalid-image-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#### Testing for GCE Disks
# Confirm exactly 6 disk violations were found
# 4 disks have violations - 2 of which have 2 violations (one has 2 labels missing,
# the other has 2 labels with invalid values)
# confirm which 4 disks are in violation
test_enforce_label_compute_disk_violations {
	violations := compute_disk_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-missing-labels",
		"//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-missing-label1",
		"//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-missing-label2",
		"//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-invalid-disk-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#### Testing for GCE Snapshots
# Confirm exactly 6 snapshot violations were found
# 4 snapshots have violations - 2 of which have 2 violations (one has 2 labels missing,
# the other has 2 labels with invalid values)
# confirm which 4 snapshots are in violation
test_enforce_label_compute_snapshot_violations {
	violations := compute_snapshot_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-missing-labels",
		"//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-missing-label1",
		"//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-missing-label2",
		"//compute.googleapis.com/projects/my-test-project/global/snapshots/snapshot-1-invalid-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#### Testing for BigTable Instances
# Confirm exactly 6 bigtable violations were found
# 4 bigtable instances have violations - 2 of which have 2 violations (one has 2 labels missing, the other has 2 labels with invalid values)
# confirm which 4 bigtable instances are in violation
test_enforce_label_bigtable_violations {
	violations := bigtable_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//bigtable.googleapis.com/projects/my-test-project/instances/test-bigtable-invalid-missing-labels",
		"//bigtable.googleapis.com/projects/my-test-project/instances/test-bigtable-invalid-missing-label1",
		"//bigtable.googleapis.com/projects/my-test-project/instances/test-bigtable-invalid-missing-label2",
		"//bigtable.googleapis.com/projects/my-test-project/instances/test-bigtable-invalid-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#### Testing for CloudSQL Instances
# Confirm exactly 6 cloudsql violations were found
# 4 cloudsql instances have violations - 2 of which have 2 violations (one has 2 labels missing, the other has 2 labels with invalid values)
# confirm which 4 cloudsql instances are in violation
test_enforce_label_cloudsql_violations {
	violations := cloudsql_violations
	count(violations) == 6

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//cloudsql.googleapis.com/projects/my-test-project/instances/cloudsql-instance-1-invalid-missing-labels",
		"//cloudsql.googleapis.com/projects/my-test-project/instances/cloudsql-instance-1-invalid-missing-label1",
		"//cloudsql.googleapis.com/projects/my-test-project/instances/cloudsql-instance-1-invalid-missing-label2",
		"//cloudsql.googleapis.com/projects/my-test-project/instances/cloudsql-instance-1-invalid-label1-and-label2-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#### Testing for Dataproc 
# Confirm exactly 12 dataproc violations were found
# 4 dataproc jobs have violations - 2 of which have 2 violations (one has 2 labels missing, 
# 4 dataproc clusters have violations - 2 of which have 2 violations (one has 2 labels missing, 
# the other has 2 labels with invalid values)
# confirm which 8 dataproc jobs are in violation
test_enforce_label_dataproc_violations {
	violations := dataproc_violations

	count(violations) == 12

	resource_names := {x | x = violations[_].details.resource}
	expected_resource_name := {
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/jobs/job-b068791b-dataproc-job-missing-label1",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/jobs/job-b068791b-dataproc-job-missing-label2",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/jobs/job-b068791b-dataproc-job-missing-labels",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/jobs/job-b068791b-dataproc-job-bad-values",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/clusters/cluster-a1b6-test-dataproc-missing-labels",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/clusters/cluster-a1b6-test-dataproc-missing-label1",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/clusters/cluster-a1b6-test-dataproc-missing-label2",
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/clusters/cluster-a1b6-test-dataproc-bad-values",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}
