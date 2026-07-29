# syntax=docker/dockerfile:1.18
FROM codex AS github-cli-downloader

USER root

ARG GH_VERSION
ARG GH_ARCHIVE_SHA256

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && archive="gh_${GH_VERSION}_linux_amd64.tar.gz" \
    && curl --fail --location --proto '=https' --tlsv1.2 \
        --output "/tmp/${archive}" \
        "https://github.com/cli/cli/releases/download/v${GH_VERSION}/${archive}" \
    && printf '%s  %s\n' "${GH_ARCHIVE_SHA256}" "/tmp/${archive}" \
        | sha256sum --check --strict \
    && tar --extract --gzip --file "/tmp/${archive}" --directory /tmp \
        "gh_${GH_VERSION}_linux_amd64/bin/gh" \
    && install --owner=root --group=root --mode=0755 \
        "/tmp/gh_${GH_VERSION}_linux_amd64/bin/gh" /opt/gh \
    && /opt/gh --version | grep --fixed-strings "gh version ${GH_VERSION}"

FROM codex

ARG IMAGE_SOURCE
ARG IMAGE_REVISION
ARG IMAGE_VERSION
ARG GH_VERSION

LABEL org.opencontainers.image.title="codex-github" \
      org.opencontainers.image.description="Codex environment for generic GitHub project workflows" \
      org.opencontainers.image.source="${IMAGE_SOURCE}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.base.name="ghcr.io/lxndrp/codex" \
      org.opencontainers.image.licenses="NOASSERTION" \
      io.github.cli.version="${GH_VERSION}"

COPY --from=github-cli-downloader /opt/gh /usr/local/bin/gh

USER 10001:10001
CMD ["codex", "remote-control"]
