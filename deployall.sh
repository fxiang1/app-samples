#!/bin/bash

samples=`ls -ld sample-* | tr -s " " | cut -d " " -f 9`

#for sample in "${samples}"; do
#  printf "Deploying $sample"
#  #oc apply -k $sample
#done

while read -r sample; do
  echo "Deploying $sample"
  oc apply -k $sample
done <<< "$samples"
