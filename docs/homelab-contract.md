# Vertrag mit `homelab`

Dieses Repository veröffentlicht Images und Metadaten. Es erzeugt keine
Synology-Instanzen und ändert das `homelab`-Repository nicht.

## Eingaben für ein späteres Deployment

`homelab` muss explizit festlegen:

- vollständige Image-Referenz mit Digest;
- `linux/amd64`;
- UID/GID `10001:10001`;
- benanntes Zustandsvolume für `/home/codex/.codex`;
- eng begrenzten Bind-Mount eines Projekts nach `/workspace`;
- `tmpfs` für `/tmp`;
- Ressourcenlimits und Restart-Regel;
- `read_only: true`, `cap_drop: ALL` und `no-new-privileges`;
- bei privaten Packages eine getrennt verwaltete `read:packages`-Referenz.

Es darf keinen Docker-Socket, keinen NAS-Wurzelmount, keine SSH-Freigabe und
keine eingehende Portfreigabe geben.

Das Zustandsvolume muss für UID/GID `10001:10001` schreibbar vorbereitet werden.
Beim ersten Start legt der unprivilegierte Entrypoint darin die zum fixierten
Codex-Release gehörende verwaltete Standalone-Struktur an.

## Beispiel, nicht als Deployment

```yaml
services:
  codex:
    image: ghcr.io/lxndrp/codex-github@sha256:<approved-digest>
    user: "10001:10001"
    read_only: true
    cap_drop: [ALL]
    security_opt: [no-new-privileges:true]
    tmpfs:
      - /tmp:rw,noexec,nosuid,nodev,size=256m,uid=10001,gid=10001,mode=1777
    volumes:
      - codex-state:/home/codex/.codex
      - /volume1/codex/test-repository:/workspace
    working_dir: /workspace
    restart: unless-stopped
```

Der konkrete Pfad, Secret-Mechanismus, Digest und die Ressourcenwerte werden
erst im `homelab`-Pull-Request festgelegt.
