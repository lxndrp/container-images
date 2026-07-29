# container-images

Private Lieferkette für wiederverwendbare, gehärtete OCI-Images. Codex ist der
erste Workload; das Repository ist nicht auf Codex beschränkt.

## Imagehierarchie

```text
ubuntu:24.04 / ubuntu:26.04
└── ghcr.io/lxndrp/container-base
    └── ghcr.io/lxndrp/codex
        └── ghcr.io/lxndrp/codex-github
```

Gebaut wird ausschließlich für `linux/amd64`. Pull Requests bauen und testen
beide Ubuntu-Varianten, veröffentlichen aber nicht. Veröffentlichungen erfolgen
erst von `main` oder einem Release-Tag. Maßgeblich für Deployments sind Digests,
nicht bewegliche Tags.

## Dokumentation

- [Architektur](docs/architecture.md)
- [Liefermodell](docs/delivery-model.md)
- [Sicherheitsmodell](docs/security.md)
- [Vertrag mit homelab](docs/homelab-contract.md)
- [Manueller Integrationstest](docs/manual-integration-test.md)

## Lokale Entwicklung

Voraussetzungen: Docker mit Buildx und Bash.

```bash
./scripts/build.sh 24.04
./scripts/smoke-test.sh 24.04

./scripts/build.sh 26.04
./scripts/smoke-test.sh 26.04
```

Die Images werden lokal als
`local/container-{base,codex,codex-github}:ubuntu<VERSION>` geladen.

## Abgrenzung

Dieses Repository enthält keine Sprach-Toolchains, projektspezifischen Images,
Synology-Konfiguration, SSH-Zugänge, Secrets, Docker-in-Docker oder
Docker-Socket-Einbindungen. Projektspezifische Erweiterungen gehören in
`containers/codex/Dockerfile` des jeweiligen Projektrepositories.
