#!/bin/sh
set -e

# Regenera chiavi SSH
ssh-keygen -A

# Assicurati che la cartella SSH esista
mkdir -p /var/run/sshd

# Avvia SSH in background
/usr/sbin/sshd -D &

# Avvia Docker se necessario
exec "$@"

