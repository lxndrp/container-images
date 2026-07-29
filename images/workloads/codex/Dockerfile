# syntax=docker/dockerfile:1.18
FROM base AS codex-downloader

USER root

ARG CODEX_VERSION
ARG CODEX_ARCHIVE_SHA256

COPY scripts/download-codex.sh /usr/local/bin/download-codex

RUN chmod 0755 /usr/local/bin/download-codex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && download-codex "${CODEX_VERSION}" "${CODEX_ARCHIVE_SHA256}" \
        /opt/codex-standalone

FROM base

ARG IMAGE_SOURCE
ARG IMAGE_REVISION
ARG IMAGE_VERSION
ARG CODEX_VERSION

LABEL org.opencontainers.image.title="codex" \
      org.opencontainers.image.description="Native Codex remote-control workload" \
      org.opencontainers.image.source="${IMAGE_SOURCE}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.base.name="ghcr.io/lxndrp/container-base" \
      org.opencontainers.image.licenses="NOASSERTION" \
      io.openai.codex.version="${CODEX_VERSION}"

ENV CODEX_VERSION="${CODEX_VERSION}"

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        git \
    && rm -rf /var/lib/apt/lists/*

COPY --from=codex-downloader --chown=10001:10001 /opt/codex-standalone/ \
    /opt/codex-standalone/
COPY --chown=10001:10001 images/workloads/codex/entrypoint.sh \
    /usr/local/bin/codex-container-entrypoint

RUN chmod 0755 /usr/local/bin/codex-container-entrypoint \
    && ln --symbolic \
        /opt/codex-standalone/current/bin/codex \
        /usr/local/bin/codex

USER 10001:10001
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/codex-container-entrypoint"]
CMD ["codex", "remote-control"]
