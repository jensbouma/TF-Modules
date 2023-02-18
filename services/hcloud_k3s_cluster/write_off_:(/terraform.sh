#!/bin/bash
CLUSTER_CA_CERT=$(cat /var/lib/rancher/k3s/server/tls/server-ca.crt | tr -d '[:space:]')
TOKEN=$(kubectl create token default | cat)
BEARER="${tf_bearer_token}"
VARSET="${cluster_varset}"
IPV4=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
EXPORT=$(cat <<EOF
{
  "data": {
    "type": "vars",
    "attributes": {
      "key": "cluster_ca",
      "value": "$CLUSTER_CA_CERT",
      "sensitive": false,
      "category": "terraform",
      "hcl": false
    }
  }
}
EOF
)
curl --header "Authorization: Bearer $BEARER" --header "Content-Type: application/vnd.api+json"  --request POST --data "$EXPORT" https://app.terraform.io/api/v2/varsets/$VARSET/relationships/vars
EXPORT=$(cat <<EOF
{
  "data": {
    "type": "vars",
    "attributes": {
      "key": "token",
      "value": "$TOKEN",
      "sensitive": false,
      "category": "terraform",
      "hcl": false
    }
  }
}
EOF
)
curl --header "Authorization: Bearer $BEARER" --header "Content-Type: application/vnd.api+json"  --request POST --data "$EXPORT" https://app.terraform.io/api/v2/varsets/$VARSET/relationships/vars
  EXPORT=$(cat <<EOF
{
  "data": {
    "type": "vars",
    "attributes": {
      "key": "cluster_ipv4",
      "value": "$IPV4",
      "sensitive": false,
      "category": "terraform",
      "hcl": false
    }
  }
}
EOF
)
curl --header "Authorization: Bearer $BEARER" --header "Content-Type: application/vnd.api+json"  --request POST --data "$EXPORT" https://app.terraform.io/api/v2/varsets/$VARSET/relationships/vars