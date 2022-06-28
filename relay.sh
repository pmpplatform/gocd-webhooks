#!/bin/sh

GO_SERVER_URL="${GO_SERVER_URL-http://localhost:8153}"
GO_API_URL="${GO_SERVER_URL}/go/api/admin/materials/git/notify"

function exit_error() {
  echo -n $1
  exit 1
}

function exit_response() {
  echo -n $2
  exit $1
}

[[ -z "$GO_API_TOKEN" ]] && exit_error "GoCD API access token not provided"
[[ -z "$MATERIAL_URL" ]] && exit_error "URL could not be found in payload"

RESPONSE=$(
  curl --silent --show-error --fail \
    "$GO_API_URL" \
    -H 'Accept: application/vnd.go.cd+json' \
    -H "Authorization: Bearer $GO_API_TOKEN" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "{\"repository_url\": \"${MATERIAL_URL}\"}"
)

exit_response $? "$RESPONSE"
