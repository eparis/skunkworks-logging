#!/bin/bash

set -e

dirs=(
fluentd
es
kibana
)

oc new-project eparis-logging
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
