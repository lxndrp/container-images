#!/bin/sh
set -eu

version="${1:?usage: download-codex.sh VERSION SHA256 DESTINATION}"
expected_sha256="${2:?usage: download-codex.sh VERSION SHA256 DESTINATION}"
destination="${3:?usage: download-codex.sh VERSION SHA256 DESTINATION}"
target="x86_64-unknown-linux-musl"
archive="codex-package-${target}.tar.gz"
release_dir="${destination}/releases/${version}-${target}"

curl --fail --location --proto '=https' --tlsv1.2 \
  --output "/tmp/${archive}" \
  "https://github.com/openai/codex/releases/download/rust-v${version}/${archive}"

printf '%s  %s\n' "${expected_sha256}" "/tmp/${archive}" \
  | sha256sum --check --strict

install --directory --mode=0755 "${release_dir}"
tar --extract --gzip --file "/tmp/${archive}" --directory "${release_dir}"
chmod 0755 \
  "${release_dir}/bin/codex" \
  "${release_dir}/bin/codex-code-mode-host" \
  "${release_dir}/codex-path/rg" \
  "${release_dir}/codex-resources/bwrap"
ln --symbolic "bin/codex" "${release_dir}/codex"
ln --symbolic "releases/${version}-${target}" "${destination}/current"
test "$("${release_dir}/bin/codex" --version)" = "codex-cli ${version}"
rm "/tmp/${archive}"
