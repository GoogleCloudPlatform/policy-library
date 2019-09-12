#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--project)
    project_id="$2"
    shift
    shift
    ;;
    -o|--organization)
    organization_id="$2"
    shift
    shift
    ;;
    -b|--bucket)
    bucket_name="$2"
    shift
    shift
    ;;
    -l|--lib)
    policy_library_path="$2"
    shift
    shift
    ;;
    -e|--export)
    export="$2"
    shift
    shift
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

check_args(){
  # Set policy_library_path to pwd if not passed
  if [ -z $policy_library_path ]
  then
    policy_library_path=$(pwd)
  fi

  # Set export to False if not passed
  if [ -z $export ]
  then
    export=false
  fi

  # Check required params are passed
  if [ -z $project_id ] && [ -z $organization_id ] || [ -z $bucket_name ]
  then
    echo "Usage: ./cft.sh [-o <org_id> | -p <project_id>] -b <bucket_name>"
    exit 1
  fi
}

print_args(){
  echo "Options: "
  echo "  - Bucket: $bucket_name"
  echo "  - Project: $project_id"
  echo "  - Organization: $organization_id"
  echo "  - Policy-library path: $policy_library_path"
  echo "  - Do CAI export ? $export"
}

setup_gcloud(){
  if [ ! -z "$project_id" ]
  then
    gcloud config set core/project $project_id
  fi
}

export_cai(){
  if [[ $bucket_name == *"forseti"* ]]; then
    echo "Forseti bucket detected. Renaming existing dumps to CFT scorecard format ..."
    export_cai_forseti
  else
    echo "No Forseti bucket detected."
    export_cai_nonforseti
  fi
}

export_cai_nonforseti(){
  # Create a bucket for CAI data
  gsutil mb gs://$bucket_name/

  # Export CAI data (project)
  if [ ! -z $project_id ]
  then
    gcloud beta asset export \
    --output-path=gs://$bucket_name/resource_inventory.json \
    --project=$project_id \
    --content-type=resource

    # Export IAM data
    gcloud beta asset export \
    --output-path=gs://$bucket_name/iam_inventory.json \
    --project=$project_id \
    --content-type=iam-policy

  # Export CAI data (organization)
  elif [ ! -z $organization_id ]
  then
    gcloud beta asset export \
    --output-path=gs://$bucket_name/resource_inventory.json \
    --organization=$organization_id \
    --content-type=resource

    # Export IAM data
    gcloud beta asset export \
    --output-path=gs://$bucket_name/iam_inventory.json \
    --organization=$organization_id \
    --content-type=iam-policy
  fi

  # Wait until complete
  sleep 5
}

export_cai_forseti(){
  # Download last 2 dumps from Forseti CAI bucket
  output=$(gsutil ls -l gs://$bucket_name | sort -k 2 | tail -n 3 | head -2 | awk '{print $3}')
  files=($output)

  # Copy resource dump to appropriate name
  gsutil cp ${files[0]} gs://$bucket_name/resource_inventory.json

  # Copy IAM dump to appropriate name
  gsutil cp ${files[1]} gs://$bucket_name/iam_inventory.json
}

download_cft(){
  # OS X
  if [[ "$OSTYPE" == "darwin"* ]]; then
    bin_name="cft-darwin-amd64"
  # Linux
  else
    bin_name="cft-linux-amd64"
  fi
  if ! [ -f cft ]; then
    echo "CFT Binary not found, downloading ..."
    curl -o cft https://storage.googleapis.com/cft-scorecard/v0.2.0/${bin_name}
    chmod +x cft
  fi
}

run_cft(){
  ./cft scorecard \
  --policy-path=$policy_library_path \
  --project=$project_id \
  --bucket=$bucket_name
}

print_args
check_args
setup_gcloud
if $export; then
  export_cai
fi
download_cft
run_cft
