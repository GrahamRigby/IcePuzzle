#!/bin/bash
set -efuox pipefail

help=$(cat <<EOF
name: create_release_branch
arguments:
  1. Release Branch Name (must be a valid name: Release-xxx)
usage:
  create_release_branch Release-Alpha-1.2
EOF
)

if [[ ! ("$#" == 1 && "$1" = Release-?*) ]]; then 
    echo 'Release Branch must be a valid name: "Release-xxx"'
    exit 1
fi
RELEASE="$1"
echo "Creating branch: ${RELEASE}"
#git checkout -b $RELEASE Development
sed -ie "s/- Development/- ${RELEASE}/g" azure-pipelines.yml
sed -ie "s/artifactName: 'Hockeystick.Marketplace.Web'/artifactName: ${RELEASE}-artifact/g" azure-pipelines.yml
echo "Pushing updated yaml file to new release branch"
git add . && git commit -m "New Release Build: ${RELEASE}" && git push -u origin $RELEASE

