# Specifications: os-shell

- **Base:** nix-built; rootfs = cacert + bash + coreutils + procps (built without systemd)
- **Shell:** `/bin/bash` (`/bin/sh` -> bash)
- **Entrypoint:** none
- **CMD:** `/bin/bash`
- **User:** 1001
- **WorkingDir:** `/`
- **Env:** `PATH=/bin`, `SSL_CERT_FILE`
- **Ports:** none
- **Persistent dirs:** none
