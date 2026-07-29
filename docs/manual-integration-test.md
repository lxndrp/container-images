# Manueller Integrationstest auf der Synology

Dieser Test wird erst nach Merge, Veröffentlichung und einem getrennt
freigegebenen `homelab`-Pull-Request ausgeführt.

## Vorbereitung

Für jede Ubuntu-Variante werden ein eigener freigegebener Digest und ein eigenes
Zustandsvolume verwendet:

| Variante | Image | Zustand |
| --- | --- | --- |
| 24.04 | `ghcr.io/lxndrp/codex-github@sha256:<digest-24>` | `codex-state-24` |
| 26.04 | `ghcr.io/lxndrp/codex-github@sha256:<digest-26>` | `codex-state-26` |

Beide Instanzen verwenden getrennte, ausdrücklich eingebundene
Testrepository-Verzeichnisse. Es gibt keine Portfreigabe.

## Ablauf je Variante

1. Package-Login auf der Synology mit einem getrennten `read:packages`-Zugang
   einrichten und das Image per Digest abrufen.
2. Container mit dem Profil aus `homelab-contract.md` starten; zunächst
   `codex login --device-auth` als einmaligen Befehl ausführen.
3. Device-Code auf einem vertrauenswürdigen Gerät bestätigen und prüfen, dass
   der Zustand im variantspezifischen Volume liegt.
4. Den Container mit dem Standardkommando `codex remote-control` im Vordergrund
   starten. Prüfen, dass kein eingehender Listener oder Port veröffentlicht ist.
5. In einer zweiten Ausführung `codex remote-control pair` starten und den
   kurzlebigen Pairing-Code ausschließlich im vorgesehenen Client verwenden.
6. Vom Mac mit demselben ChatGPT-Konto und Workspace verbinden, einen neuen Chat
   im eingebundenen Testrepository beginnen und eine harmlose Dateiänderung
   erzeugen.
7. Container stoppen und mit identischem Image-Digest sowie identischem
   Zustandsvolume neu starten. Prüfen, dass der Chat fortgesetzt werden kann.
8. Im Testrepository `git status`, `git fetch` und einen Testbranch ausführen.
   Für GitHub-Funktionen Authentifizierung nur zur Laufzeit bereitstellen und
   anschließend widerrufen.
9. Containerinspektion dokumentieren: Digest, UID/GID, Mounts, `read_only`,
   Capability-Set, Security-Optionen, fehlende Portfreigaben und Ressourcen.
10. Zustand der 24.04- und 26.04-Variante darf sich nicht überschneiden.

## Abbruch- und Rollbackkriterien

Abbrechen bei Root-Ausführung, Schreibzugriff außerhalb der Mounts, offenem
Port, fehlender Prüfsummen-/Digest-Zuordnung, verlorener Chatpersistenz oder
unerwartetem Zugriff auf NAS-Pfade. Rollback bedeutet: Container stoppen,
vorherigen freigegebenen Digest einsetzen und das betroffene Zustandsvolume
nicht automatisch löschen.
