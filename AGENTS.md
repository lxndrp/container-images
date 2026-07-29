# AGENTS.md

## Scope

This repository builds reusable OCI images. Keep workload-independent hardening
in `images/base`, Codex runtime concerns in `images/workloads/codex`, and only
generic GitHub workflow support in `images/environments/github`.

Project-specific system dependencies and language toolchains belong in the
project repository, normally under `containers/codex/`.

## Security boundaries

- Never add credentials, tokens, private keys, or authentication state.
- Do not add SSH, Docker-in-Docker, a Docker socket, privileged operation, or
  inbound listeners.
- Keep the runtime user unprivileged (UID/GID 10001).
- Preserve read-only-root compatibility, `cap_drop: ALL`, and
  `no-new-privileges`.
- Pin upstream images, release artifacts, checksums, and GitHub Actions.
- Pull requests may build and test, but must not publish.
- Do not introduce an unreviewed deployment cascade into project or homelab
  repositories.

## Validation

Run both variants before publishing:

```bash
./scripts/build.sh 24.04
./scripts/smoke-test.sh 24.04
./scripts/build.sh 26.04
./scripts/smoke-test.sh 26.04
./scripts/lint.sh
```

Inspect `git diff --check` as a final focused check.
