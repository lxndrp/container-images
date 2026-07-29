# Liefermodell

```text
Upstream-Image
    ↓
wiederverwendbares Image aus container-images
    ↓
gegebenenfalls projektspezifisches Image
    ↓
Deployment-Änderung im homelab-Repository
    ↓
Betrieb auf der Synology
```

## Kontrollierter Updatefluss

1. Upstream-Ubuntu-Digest oder Codex-/GitHub-CLI-Version und Prüfsumme in einem
   Pull Request aktualisieren.
2. Beide Ubuntu-Varianten bauen und testen.
3. Nach Review und Merge wiederverwendbare Images veröffentlichen.
4. Falls nötig, projektspezifisches Image per eigenem Pull Request aktualisieren
   und testen.
5. Den freigegebenen Image-Digest per Pull Request im `homelab`-Repository
   ändern.
6. Kontrolliert deployen; den vorherigen Digest als Rollbackziel dokumentieren.

Kein Schritt löst ungeprüft den nächsten Repository- oder Deployment-Schritt
aus. Dependabot darf Aktualisierungen vorschlagen, ersetzt aber weder Review
noch Tests.

## Tags

Lesbare Tags:

```text
ubuntu24.04
ubuntu26.04
0.146.0-ubuntu24.04
0.146.0-ubuntu26.04
sha-<commit>-ubuntu24.04
sha-<commit>-ubuntu26.04
```

`container-base` verwendet anstelle der Codex-Version eine Repositoryversion.
Tags dienen der Auffindbarkeit. Deploymentreferenzen verwenden stets
`ghcr.io/lxndrp/<image>@sha256:<digest>`.
