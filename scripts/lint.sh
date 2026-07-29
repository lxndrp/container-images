#!/usr/bin/env bash
set -euo pipefail

docker buildx bake --print >/dev/null

if rg --glob 'Dockerfile' --glob '*.hcl' \
  '(?i)(ARG|ENV)[[:space:]]+(.*TOKEN|.*PASSWORD|.*SECRET|.*PRIVATE_KEY)' .; then
  printf 'secret-like build argument or environment variable found\n' >&2
  exit 1
fi

if rg --glob 'Dockerfile' \
  '(^|[[:space:]])(EXPOSE|VOLUME)[[:space:]]|docker\\.sock|--privileged' images; then
  printf 'forbidden runtime declaration found\n' >&2
  exit 1
fi

for file in scripts/*.sh; do
  bash -n "${file}"
done

printf 'Static checks passed\n'
