#!/usr/bin/env bash
set -euo pipefail

PRIMARY_QUEUE=${PRIMARY_QUEUE:-"mac"}
SECONDARY_QUEUE=${SECONDARY_QUEUE:-"default"}
MIN_AVAILABLE=${MIN_AVAILABLE:-1}
ORG_SLUG=${ORG_SLUG:-${BUILDKITE_ORGANIZATION_SLUG:-""}}

if [[ -z "$ORG_SLUG" ]]; then
  echo "ORG_SLUG (or BUILDKITE_ORGANIZATION_SLUG) must be set" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required on the agent to parse GraphQL responses" >&2
  exit 1
fi

GRAPHQL_QUERY=$(cat <<'EOF'
query OrgAgents($slug: ID!) {
  organization(slug: $slug) {
    agents(first: 200) {
      edges {
        node {
          id
          name
          connectionState
          metaData
          job {
            __typename
          }
        }
      }
    }
  }
}
EOF
)

TOKEN=${BUILDKITE_API_TOKEN:-${API_ACCESS_TOKEN:-}}
if [[ -z "$TOKEN" ]]; then
  echo "BUILDKITE_API_TOKEN must be set with GraphQL access" >&2
  exit 1
fi

fetch_agents() {
  local response
  response=$(curl -sS -X POST https://graphql.buildkite.com/v1 \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg slug "$ORG_SLUG" --arg query "$GRAPHQL_QUERY" \
           '{ query: $query, variables: { slug: $slug } }')")

  echo "GraphQL response:" >&2
  echo "$response" | jq '.' >&2 || echo "$response" >&2

  echo "$response"
}

has_capacity() {
  local queue="$1"
  local available

  available=$(fetch_agents | jq --arg queue "$queue" '[.data.organization.agents.edges[].node
    | select(((.metaData // []) | index("queue=" + $queue)) and .connectionState == "connected" and (.job == null))
  ]
  | length')

  [[ "$available" -ge "$MIN_AVAILABLE" ]]
}

target_queue="$PRIMARY_QUEUE"

if ! has_capacity "$PRIMARY_QUEUE"; then
  echo "Primary queue '$PRIMARY_QUEUE' lacks available agents; falling back to '$SECONDARY_QUEUE'."
  target_queue="$SECONDARY_QUEUE"
else
  echo "Primary queue '$PRIMARY_QUEUE' has capacity; proceeding."
fi

cat <<EOF | buildkite-agent pipeline upload
steps:
  - label: "Build"
    command: "echo 'Simulated build'"
    agents:
      queue: "$target_queue"

  - wait

  - label: "Test"
    command: "echo 'Running tests'"
    agents:
      queue: "$target_queue"
EOF
