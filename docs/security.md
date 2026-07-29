# Sicherheitsmodell

## Laufzeitprofil

Der vorgesehene Betrieb verwendet:

```yaml
user: "10001:10001"
read_only: true
cap_drop: [ALL]
security_opt:
  - no-new-privileges:true
tmpfs:
  - /tmp:rw,noexec,nosuid,nodev,size=256m,uid=10001,gid=10001,mode=1777
volumes:
  - codex-state:/home/codex/.codex
  - /explicit/project/path:/workspace
```

Es gibt keine privilegierte Ausführung, keinen Docker-Socket und keinen Zugriff
auf das gesamte NAS-Dateisystem. Das Image öffnet keine Ports. Remote Control
verwendet ausschließlich den ausgehenden, authentifizierten Relay-Kanal.

Codex' innere Linux-Sandbox kann in einem streng gehärteten Container wegen
fehlender Namespace- oder Bubblewrap-Rechte eingeschränkt sein. Die äußere
Containergrenze ist deshalb Teil des Sicherheitsmodells; zusätzliche
Capabilities werden nicht stillschweigend gewährt.

## Zustände und Secrets

`/home/codex/.codex` ist persistenter Anwendungszustand.
`/workspace` enthält ausschließlich explizit eingebundene Repositories.
`/tmp` ist flüchtig und wird als `tmpfs` bereitgestellt.

Tokens, Device-Codes und ChatGPT-/GitHub-Anmeldedaten dürfen weder als Build-Arg
noch per `COPY` in das Image gelangen. Laufzeitvariablen sind möglich, aber
Secrets-Dateien oder ein externer Secret-Provider sind für dauerhafte
Deployments vorzuziehen. Logs dürfen keine Tokenwerte ausgeben.

## Lieferkette

- Ubuntu, Codex und GitHub CLI sind auf Version und Digest beziehungsweise
  Prüfsumme fixiert.
- GitHub Actions sind auf vollständige Commit-SHAs fixiert.
- Builds erzeugen SBOM und maximale BuildKit-Provenance.
- PRs besitzen nur Leserechte und dürfen keine Packages veröffentlichen.
- Publish-Jobs erhalten `packages: write` ausschließlich auf `main` oder
  Release-Tags.
- Es gibt kein maßgebliches `latest`.

GitHub-native Artifact Attestations für private Repositories hängen vom
GitHub-Tarif ab. Die in GHCR gespeicherten BuildKit-OCI-Attestierungen werden
unabhängig davon erzeugt; eine spätere Aktivierung zusätzlicher GitHub
Attestations kann nach Tarifprüfung erfolgen.

## Private und öffentliche Packages

Private GHCR-Packages erfordern auf der Synology einen nur lesenden
`read:packages`-Zugang. Dieser wird ausschließlich im Deployment-System
verwaltet. Bei öffentlicher Sichtbarkeit entfällt der Pull-Login, gleichzeitig
werden Imageinhalt, Metadaten, SBOM und Provenance öffentlich einsehbar. Die
Sichtbarkeit wird nicht automatisch geändert.
