#!/bin/bash

oc adm policy add-scc-to-user hostmount-anyuid -z eparis-fluentd-es
oc adm policy add-scc-to-user anyuid -z eparis-elasticsearch-logging
