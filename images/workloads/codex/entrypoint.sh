#!/bin/sh
set -eu

release_name="${CODEX_VERSION:?CODEX_VERSION must be set}-x86_64-unknown-linux-musl"
source_release="/opt/codex-standalone/releases/${release_name}"
runtime_root="${CODEX_HOME}/packages/standalone"
runtime_release="${runtime_root}/releases/${release_name}"

mkdir -p "${runtime_root}/releases"
if [ ! -x "${runtime_release}/bin/codex" ]; then
  cp -R "${source_release}" "${runtime_release}"
fi
ln -sfn "releases/${release_name}" "${runtime_root}/current"

exec "$@"
