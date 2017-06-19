#!/bin/bash

set -o errexit
set -o pipefail
set -o xtrace

pushd "sol"

mkdir -p abi
mkdir -p bin
mkdir -p doc

solc --abi --overwrite -o ../abi/ Gimli.sol
find ../abi/ -type f ! -name 'Gimli.*' -delete

solc --bin --overwrite -o ../bin/ Gimli.sol
find ../bin/ -type f ! -name 'Gimli.*' -delete

solc --userdoc --devdoc --overwrite -o ../doc/ Gimli.sol
find ../doc/ -type f ! -name 'Gimli.*' -delete

popd
