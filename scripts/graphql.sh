#!/bin/bash

BASE_URL=$1
BEARER_TOKEN=$2
REPOSITORY_KEY=$3
NAME=$4
VERSION=$5

export REPOSITORY_KEY NAME VERSION

QUERY=$(envsubst < scripts/graphql_query.gql)

curl -X POST "${BASE_URL}/evidence/api/v1/onemodel/graphql" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${BEARER_TOKEN}" \
  -d "$QUERY" -o evidence_graph.json
