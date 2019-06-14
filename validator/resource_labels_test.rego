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
import data.test.fixtures.resource_labels.assets.projects as fixture_projects
import data.test.fixtures.resource_labels.constraints as fixture_constraints

# Find all violations on our test cases
find_all_violations[violation] {
        resources := data.resources[_]
        constraint := data.test_constraints[_]
        issues := deny with input.asset as resources
                 with input.constraint as constraint
        violation := issues[_]
}

projects_violations[violation] {
        constraints := [fixture_constraints.require_labels]
        violations := find_all_violations with data.resources as fixture_projects
                 with data.test_constraints as constraints
        violation := violations[_]
}


# # Confirm only a single violation was found for projects
test_resource_label_projects_violates_project_one {
        violations := projects_violations
        count(violations) == 2
        violation := violations[_]
        is_string(violation.msg)
        is_object(violation.details)
}

# confirm which 2 projects are in violation
test_resource_label_projects_violates_project_basic { 
        violations := projects_violations
	projects_violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/357960133769"
	projects_violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/169463810970"
}