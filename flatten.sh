#!/bin/bash

for contract in `find contracts -name "*.sol"`
do
  mkdir -p `dirname contracts_flattened/$contract`
  npx hardhat flatten $contract > contracts_flattened/$contract
  echo $contract
done
