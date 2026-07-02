#!/usr/bin/env bash
# percona-server docker-entrypoint.sh
#
# The image's old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops).
# mysqld also needs an initialized data directory before it can start. On first
# boot, initialize an insecure datadir (root@localhost, no password) under the
# writable /tmp mkImage provides, then exec the server bound on 0.0.0.0:3306.
# The image runs as uid 65534 (non-root), so mysqld's run-as-root guard is not
# triggered. Operators mount their own volume at /tmp/mysql (or override the
# command) for real, secured data.
set -euo pipefail

DATADIR="${MYSQL_DATADIR:-/tmp/mysql}"

# Pass non-server invocations straight through (e.g. `mysqld --help`,
# `mysqld --version`) without initializing or starting the server.
if [ "$#" -gt 0 ]; then
  exec mysqld "$@"
fi

mkdir -p "$DATADIR"

# Initialize the datadir on first boot (idempotent — the mysql system schema
# dir exists once initialized).
if [ ! -d "$DATADIR/mysql" ]; then
  echo "[entrypoint] initializing datadir at $DATADIR"
  mysqld --initialize-insecure --datadir="$DATADIR" --tmpdir=/tmp
fi

echo "[entrypoint] starting mysqld"
exec mysqld \
  --datadir="$DATADIR" \
  --bind-address=0.0.0.0 \
  --socket=/tmp/mysqld.sock \
  --pid-file=/tmp/mysqld.pid \
  --tmpdir=/tmp \
  --mysqlx=OFF
