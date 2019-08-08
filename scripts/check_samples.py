# Copyright 2019 Google LLC
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

import yaml
import os
import re
import glob
import sys

def check_template_sample(template_file_name):

    # retrieve the template kind
    with open(template_file_name, 'r') as template_file:
        
        template_kind = re.findall('kind:\s+(\w+)', template_file.read())[1]
        string_to_match = 'kind:\s+{}'.format(template_kind)
        sample_found = False

        # # check if one sample uses that template kind
        for sample_file_name in glob.glob("samples/*.yaml"):
            with open(sample_file_name, 'r') as sample_file:
                sample_found = re.search(string_to_match, sample_file.read())
                if(sample_found):
                    break
        
    # if not, error out
    if( not sample_found):
        print("No sample found for template {} ({})".format(template_file_name, template_kind))
        sys.exit(1)


def check_template_samples():
    print("Verifying sample files for all templates...")
    for template_file_name in glob.glob("policies/templates/*.yaml"):
        check_template_sample(template_file_name)
    print("All templates have a sample associated in samples/")
check_template_samples()
