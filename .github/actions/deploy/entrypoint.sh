#!/bin/bash

set -e
set -x
set -o pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi
cd "$GITHUB_WORKSPACE"
hugo version
echo "Preparing to build blog"
hugo -D
echo "Building is done. Copying over generated files"
cd public
sshpass -e sftp "$1@home279202417.1and1-data.host" << !
  put -r .
  exit
!
echo "Copy is done."

exit 0