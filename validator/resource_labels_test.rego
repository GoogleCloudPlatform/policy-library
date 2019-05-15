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
import data.test.fixtures.assets.projects as fixture_projects
import data.test.fixtures.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
        project := data.projects[_]
        constraint := data.test_constraints[_]
        issues := deny with input.asset as project
                 with input.constraint as constraint
        total_issues := count(issues)
        violation := issues[_]
}

projects_violations[violation] {
        constraints := [fixture_constraints.require_labels]
        found_violations := find_violations with data.projects as fixture_projects
                 with data.test_constraints as constraints
        violation := found_violations[_]
}


# Confirm only a single violation was found (resource_labels constraint)
test_resource_label_projects_violates_one {
        found_violations := projects_violations
        count(found_violations) == 1
        violation := found_violations[_]
        is_string(violation.msg)
        is_object(violation.details)
}
