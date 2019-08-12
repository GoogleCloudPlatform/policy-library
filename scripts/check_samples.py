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
"""
Check that each template in policies/templates has an associated sample in samples/
"""
import glob
import sys
import yaml

def check_template_sample(template_file_name):
    """
    check_template_sample checks if a template has a sample associated in the samples/ folder

    Args:
        template_file_name: the template file path to check
    Raises:
        yaml.YAMLError if the input template or any sample file is not a valid YAML file
    """

    # retrieve the template kind
    with open(template_file_name, 'r') as template_file:
        try:
            template_object = yaml.safe_load(template_file)
            template_kind = template_object["spec"]["crd"]["spec"]["names"]["kind"]
            sample_found = False

            # check if one sample uses that template kind
            for sample_file_name in glob.glob("samples/*.yaml"):
                with open(sample_file_name, 'r') as sample_file:
                    try:
                        sample_object = yaml.safe_load(sample_file)
                        sample_kind = sample_object["kind"]
                        sample_found = sample_kind == template_kind

                        if sample_found:
                            break
                    except yaml.YAMLError as error:
                        print("Error parsing sample {}: {}".format(sample_file, error))
                        sys.exit(1)

            # if not, error out
            if not sample_found:
                print("No sample found for template {} ({})".format(template_file_name, template_kind))
            
            return sample_found

        except yaml.YAMLError as error:
            print("Error parsing template {}: {}".format(template_file_name, error))
            sys.exit(1)

def check_template_samples():
    """
    check_template_samples runs check_template_sample on all templates in policies/
    """
    
    # Default missing_sample to False
    missing_sample = False

    print("Verifying sample files for all templates...")
    # Reccurisvely look for templates in the policies/ folder
    for template_file_name in glob.glob("policies/*/*.yaml"):
        
        # only run the check_template_sample function on actual template
        with open(template_file_name, 'r') as template_file:
            try:
                template_object = yaml.safe_load(template_file)
                
                if template_object["kind"] == "ConstraintTemplate":
                    check_template_sample(template_file_name)

            except yaml.YAMLError as error:
                print("Error parsing YAML file {}: {}".format(template_file_name, error))
                sys.exit(1)       
   
    if not missing_sample:
        print("All templates have a sample associated in samples/")
    else:
        # if one or more template has no sample associated then returns an exit code of 1
        sys.exit(1) 

check_template_samples()
