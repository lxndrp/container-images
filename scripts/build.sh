#!/usr/bin/env bash
set -euo pipefail

ubuntu_version="${1:?usage: scripts/build.sh 24.04|26.04}"

case "${ubuntu_version}" in
  24.04)
    ubuntu_digest="sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90"
    ;;
  26.04)
    ubuntu_digest="sha256:3131b4cc82a783df6c9df078f86e01819a13594b865c2cad47bd1bca2b7063bb"
    ;;
  *)
    printf 'unsupported Ubuntu version: %s\n' "${ubuntu_version}" >&2
    exit 2
    ;;
esac

export UBUNTU_VERSION="${ubuntu_version}"
export UBUNTU_DIGEST="${ubuntu_digest}"
export IMAGE_REVISION="${GITHUB_SHA:-local}"
export REVISION_SHORT="${IMAGE_REVISION:0:12}"

docker buildx bake --load
