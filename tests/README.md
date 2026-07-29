# Tests

Executable smoke tests live in `scripts/smoke-test.sh` so the same checks run
locally and in GitHub Actions. They validate the image contract under a
read-only root filesystem with all capabilities dropped and
`no-new-privileges`.
