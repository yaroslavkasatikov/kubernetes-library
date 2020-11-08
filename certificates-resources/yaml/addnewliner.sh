#!/bin/bash
SECRET_NAME=apps-certificate
PROJECT_NAME=openshift-ingress
oc get secrets $SECRET_NAME -n $PROJECT_NAME -o jsonpath="{['data.tls\.crt']}"|base64 -d  > tls.crt
sed -i -e '$a\' tls.crt

cert=$(cat tls.crt|base64| tr -d '\n' )
key=$(cat tls.key|base64| tr -d '\n' )
oc patch secret $SECRET_NAME -n $PROJECT_NAME -p "{\"data\": {\"tls.crt\": \"$cert\"}}"
oc patch ingresscontroller.operator default \
     --type=merge -p \
     "{\"spec\":{\"defaultCertificate\": {\"name\": \"$SECRET_NAME\"}}}" \
     -n openshift-ingress-operator

