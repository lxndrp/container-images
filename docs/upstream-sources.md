# Upstream-Quellen und Pins

Stand: 29. Juli 2026.

| Bestandteil | Pin | Verifikation |
| --- | --- | --- |
| Ubuntu 24.04 | `ubuntu:24.04@sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90` | offizieller OCI-Index auf Docker Hub |
| Ubuntu 26.04 | `ubuntu:26.04@sha256:3131b4cc82a783df6c9df078f86e01819a13594b865c2cad47bd1bca2b7063bb` | offizieller OCI-Index auf Docker Hub |
| Codex | `0.146.0` | offizielles [Release](https://github.com/openai/codex/releases/tag/rust-v0.146.0), Paketprüfsumme `3c89125af1d7c98abec8beb551292ef99daca52e204e5852a9139feae2c467e5` aus `codex-package_SHA256SUMS` |
| GitHub CLI | `2.96.0` | offizielles [Release](https://github.com/cli/cli/releases/tag/v2.96.0), Archivprüfsumme `83d5c2ccad5498f58bf6368acb1ab32588cf43ab3a4b1c301bf36328b1c8bd60` |

Die Codex-CLI dokumentiert `remote-control` als experimentell und beschreibt
den Vordergrundbetrieb sowie `pair` für kurzlebige manuelle Pairing-Codes in
der offiziellen
[CLI-Referenz](https://developers.openai.com/codex/cli/reference/#codex-remote-control).
Der Standalone-Installer und seine erwartete Verzeichnisstruktur stammen aus
dem offiziellen
[Codex-Repository](https://github.com/openai/codex/blob/main/scripts/install/install.sh).

GitHub dokumentiert das Publizieren von Container-Images in GHCR und
Build-Provenance in der
[Actions-Dokumentation](https://docs.github.com/en/actions/tutorials/publish-packages/publish-docker-images).

Pins werden ausschließlich per Pull Request aktualisiert. Ein neuer Tag allein
ändert keinen laufenden Container und löst keine Kaskade in Projekt- oder
Homelab-Repositories aus.
