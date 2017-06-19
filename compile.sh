#!/bin/bash

set -o errexit
set -o pipefail
set -o xtrace

pushd "sol"

mkdir -p abi
mkdir -p bin
mkdir -p doc

solc --abi --overwrite -o ../abi/ Gimli.sol
solc --bin --overwrite -o ../bin/ Gimli.sol
solc --userdoc --devdoc --overwrite -o ../doc/ Gimli.sol
