#!/bin/bash

oc delete clusterrolebinding eparis-elasticsearch-logging
oc delete clusterrolebinding eparis-fluentd-es
oc delete clusterrole eparis-elasticsearch-logging
oc delete clusterrole eparis-fluentd-es
oc adm policy remove-scc-from-user hostmount-anyuid -z eparis-fluentd-es
oc adm policy remove-scc-from-user anyuid -z eparis-elasticsearch-logging
oc adm policy remove-scc-from-user privileged -z eparis-elasticsearch-logging
oc delete project eparis-logging
oc project default
watch -n1 oc get project eparis-logging
