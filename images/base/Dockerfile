# syntax=docker/dockerfile:1.18
ARG UBUNTU_VERSION=24.04
ARG UBUNTU_DIGEST=sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90
FROM ubuntu:${UBUNTU_VERSION}@${UBUNTU_DIGEST}

ARG IMAGE_SOURCE
ARG IMAGE_REVISION
ARG IMAGE_VERSION
ARG UBUNTU_VERSION

LABEL org.opencontainers.image.title="container-base" \
      org.opencontainers.image.description="Minimal hardened runtime base for reusable workloads" \
      org.opencontainers.image.source="${IMAGE_SOURCE}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.base.name="docker.io/library/ubuntu:${UBUNTU_VERSION}" \
      org.opencontainers.image.licenses="NOASSERTION"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ca-certificates \
        tini \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 10001 codex \
    && useradd --uid 10001 --gid 10001 --home-dir /home/codex \
        --shell /bin/bash --no-log-init codex \
    && install --directory --owner=10001 --group=10001 --mode=0755 \
        /home/codex /home/codex/.codex /workspace \
    && chmod 1777 /tmp

ENV HOME=/home/codex \
    CODEX_HOME=/home/codex/.codex \
    TMPDIR=/tmp

WORKDIR /workspace
USER 10001:10001
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/bash"]
