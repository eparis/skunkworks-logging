#!/bin/bash

set -e

dirs=(
fluentd
es
kibana
)

oc new-project eparis-logging

oc annotate namespace eparis-logging 'quota.openshift.io/cluster-resource-override-enabled=false'
oc annotate namespace eparis-logging 'openshift.io/node-selector='

for quota in $(oc get quota --no-headers | cut -f 1 -d ' '); do
  oc delete quota "${quota}"
done

oc delete limitrange resource-limits

for dir in "${dirs[@]}"; do
  pushd "${dir}" > /dev/null
    files=($(ls))
    for file in "${files[@]}"; do
      oc create -f "${file}"
    done
  popd > /dev/null
done
oc adm policy add-scc-to-user hostmount-anyuid -z eparis-fluentd-es
oc adm policy add-scc-to-user anyuid -z eparis-elasticsearch-logging

for pod in $(oc get pod -o json | jq '.items[].metadata.name' | tr -d '"'); do
  oc delete pod "${pod}"
done
