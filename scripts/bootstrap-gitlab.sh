#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

: "${GITLAB_TOKEN:=glpat-backstage-development-token-0001}"

echo 'Waiting for GitLab to become healthy...'
until [[ -n "$(docker compose ps -q gitlab)" ]] &&
  [[ "$(docker inspect --format '{{.State.Health.Status}}' "$(docker compose ps -q gitlab)" 2>/dev/null)" == 'healthy' ]]; do
  sleep 10
done

docker compose exec -T -e BACKSTAGE_GITLAB_TOKEN="$GITLAB_TOKEN" gitlab \
  gitlab-rails runner "
user = User.find_by_username!('root')
token = user.personal_access_tokens.find_or_initialize_by(name: 'Backstage development')
token.scopes = [:api]
token.expires_at = 1.year.from_now.to_date
token.set_token(ENV.fetch('BACKSTAGE_GITLAB_TOKEN'))
token.save!
puts 'Backstage GitLab token is ready.'
"
