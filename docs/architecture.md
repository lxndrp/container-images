# Architektur

## Entscheidung

Das Repository bildet drei klar getrennte Ebenen:

1. `container-base`: minimales, workloadunabhängiges Ubuntu-Laufzeitfundament;
2. `codex`: nativer Codex-Workload plus Git;
3. `codex-github`: generische GitHub-Projektarbeit plus GitHub CLI.

Ubuntu 24.04 LTS und 26.04 LTS werden parallel aus demselben Quellstand gebaut.
Die Auswahl ist eine Matrixdimension, keine implizite Empfehlung für eine der
Versionen. Zunächst wird nur `linux/amd64` erzeugt.

## Basisimage

Das Basisimage enthält ausschließlich:

- Ubuntu mit festgelegtem OCI-Index-Digest;
- aktuelle CA-Zertifikate aus dem jeweiligen Ubuntu-Archiv;
- `tini`;
- den Benutzer `codex` mit UID/GID `10001`;
- `/workspace`, `/home/codex` und `/tmp` mit klarer Zuständigkeit.

Es enthält bewusst keine Shell-Toolbox, Downloadprogramme, Sprachlaufzeiten,
Paketmanager-Erweiterungen oder Netzwerkdienste. APT-Listen werden im selben
Layer entfernt. Das Image deklariert weder `EXPOSE` noch `VOLUME`, damit der
Betrieb alle Mounts explizit festlegen muss.

## Codex-Workload

Codex `0.146.0` wird als offizielles natives
`codex-package-x86_64-unknown-linux-musl.tar.gz` in einer separaten Buildstufe
geladen. Die veröffentlichte SHA-256-Prüfsumme wird vor dem Entpacken geprüft.
Die Laufzeit enthält kein Node.js, npm, curl oder anderes Downloadwerkzeug.

Das offizielle Standalone-Paket wird statt nur der losgelösten Binärdatei
übernommen. Diese begründete Präzisierung ist erforderlich, weil
`codex remote-control` die verwaltete Struktur unter
`$CODEX_HOME/packages/standalone/current` erwartet. Das Paket enthält die
native Codex-Binärdatei und deren offizielle Laufzeitressourcen. Ein Symlink
stellt `codex` auf dem `PATH` bereit. Beim Containerstart kopiert ein
unprivilegierter Bootstrap die fixierte Release-Struktur bei Bedarf in das
eingebundene Codex-Zustandsvolume und setzt dessen `current`-Symlink. So bleibt
die Installation auch dann sichtbar, wenn `/home/codex/.codex` vollständig
persistiert wird; das Root-Dateisystem bleibt schreibgeschützt.

Git ist die einzige zusätzliche allgemeine Entwicklungsfunktion dieser Ebene.
Der Entrypoint startet standardmäßig `codex remote-control` im Vordergrund.
Andere Codex-Unterbefehle können als Containerargumente übergeben werden.

## GitHub-Projektumgebung

Diese Ebene ergänzt ausschließlich die native GitHub CLI. Das offizielle
Release-Archiv wird mit der veröffentlichten SHA-256-Prüfsumme geprüft.
Authentifizierung erfolgt zur Laufzeit, beispielsweise über `GH_TOKEN`, einen
kurzlebigen Token-Provider oder interaktive Geräteanmeldung. Nichts davon wird
in Layer geschrieben.

Die Ebene endet bei generischen Clone-, Fetch-, Branch-, Commit-, Pull-Request-
und Review-Abläufen. Benötigt ein Projekt Compiler, Browser, Datenbankclient,
Systembibliotheken oder E2E-Werkzeuge, muss es in seinem eigenen Repository ein
abgeleitetes Image unter `containers/codex/Dockerfile` definieren.

## Buildgraph und Metadaten

`docker-bake.hcl` beschreibt den gerichteten Buildgraphen. Nachgelagerte Images
verwenden vorherige Targets als benannte Build-Kontexte; dadurch testen Pull
Requests die echte Hierarchie, ohne Zwischenimages veröffentlichen zu müssen.

Alle Ebenen erhalten mindestens:

- `org.opencontainers.image.source`;
- `org.opencontainers.image.revision`;
- `org.opencontainers.image.version`;
- `org.opencontainers.image.base.name`;
- `org.opencontainers.image.licenses`.

Der Build erzeugt BuildKit-SBOM und SLSA-Provenance als OCI-Attestierungen.
