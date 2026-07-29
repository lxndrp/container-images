#!/usr/bin/env bash
set -euo pipefail

ubuntu_version="${1:?usage: scripts/smoke-test.sh 24.04|26.04}"
suffix="ubuntu${ubuntu_version}"
base_image="local/container-base:${suffix}"
codex_image="local/codex:${suffix}"
github_image="local/codex-github:${suffix}"

state_dir="$(mktemp -d)"
workspace_dir="$(mktemp -d)"
chmod 0777 "${state_dir}" "${workspace_dir}"
cleanup() {
  rm -rf "${state_dir}" "${workspace_dir}"
}
trap cleanup EXIT

runtime_flags=(
  --rm
  --read-only
  --cap-drop ALL
  --security-opt no-new-privileges
  --tmpfs /tmp:rw,noexec,nosuid,nodev,size=64m,uid=10001,gid=10001,mode=1777
)

mount_flags=(
  --volume "${state_dir}:/home/codex/.codex"
  --volume "${workspace_dir}:/workspace"
)

assert_user() {
  local image="$1"
  test "$(docker image inspect --format '{{.Config.User}}' "${image}")" = "10001:10001"
}

assert_no_ports() {
  local image="$1"
  test "$(docker image inspect --format '{{json .Config.ExposedPorts}}' "${image}")" = "null"
}

assert_labels() {
  local image="$1"
  local label
  for label in \
    org.opencontainers.image.source \
    org.opencontainers.image.revision \
    org.opencontainers.image.version \
    org.opencontainers.image.base.name; do
    test -n "$(docker image inspect --format "{{ index .Config.Labels \"${label}\" }}" "${image}")"
  done
}

for image in "${base_image}" "${codex_image}" "${github_image}"; do
  assert_user "${image}"
  assert_no_ports "${image}"
  assert_labels "${image}"
  docker run "${runtime_flags[@]}" "${mount_flags[@]}" "${image}" /usr/bin/tini --version
done

docker run "${runtime_flags[@]}" "${base_image}" \
  sh -c 'test "$(id -u)" = 10001 && touch /tmp/write-test'

docker run "${runtime_flags[@]}" "${mount_flags[@]}" "${codex_image}" \
  sh -c 'test "$(id -u)" = 10001; codex --version | grep -Fx "codex-cli 0.146.0"; git --version; ! command -v gh; ! command -v curl; ! command -v node; ! command -v npm'

docker run "${runtime_flags[@]}" "${mount_flags[@]}" "${codex_image}" \
  codex remote-control --help

docker run "${runtime_flags[@]}" "${mount_flags[@]}" "${github_image}" \
  sh -c 'git --version; gh --version | grep -F "gh version 2.96.0"; ! command -v curl; ! command -v node; ! command -v npm; touch "$CODEX_HOME/state-write-test"; touch /workspace/workspace-write-test; touch /tmp/tmp-write-test'

test -f "${state_dir}/state-write-test"
test -f "${workspace_dir}/workspace-write-test"

printf 'Smoke tests passed for Ubuntu %s\n' "${ubuntu_version}"
