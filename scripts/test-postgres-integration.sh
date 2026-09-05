#!/usr/bin/env bash

set -euo pipefail

readonly project_name="backstage-integration-${USER:-ci}-$$"
readonly compose_file="docker/compose.integration.yaml"

if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker with the Compose plugin is required for integration tests.\n' >&2
  exit 127
fi

cleanup() {
  docker compose --project-name "$project_name" --file "$compose_file" down --volumes --remove-orphans
}
trap cleanup EXIT

docker compose \
  --project-name "$project_name" \
  --file "$compose_file" \
  up \
  --abort-on-container-exit \
  --exit-code-from postgres-test
