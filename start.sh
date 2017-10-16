#!/bin/bash

set -e

dirs=(
fluentd
es
kibana
)

oc new-project eparis-logging

oc annotate namespace eparis-logging 'quota.openshift.io/cluster-resource-override-enabled=false'

for quota in $(oc get quota --no-headers | cut -f 1 -d ' '); do
  oc delete quota "${quota}"
done

for dir in "${dirs[@]}"; do
  pushd "${dir}" > /dev/null
    files=($(ls))
    for file in "${files[@]}"; do
      oc create -f "${file}"
    done
  popd
done
oc adm policy add-scc-to-user hostmount-anyuid -z eparis-fluentd-es
oc adm policy add-scc-to-user anyuid -z eparis-elasticsearch-logging
