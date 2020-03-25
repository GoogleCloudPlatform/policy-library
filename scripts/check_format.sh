#!/bin/bash

set -euo pipefail

diff="$(opa fmt -d lib/ validator/)"

if [[ "$diff" == "" ]]; then
  exit
fi

echo "Formating error:"
echo "$diff"
echo ""
echo "Run \"make format\" in your client to fix."
exit 1
