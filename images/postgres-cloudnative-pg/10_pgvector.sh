#!/usr/bin/env bash
# pgvector first-boot initializer.
#
# Sourced by docker-entrypoint.sh's /docker-entrypoint-initdb.d loop on an empty
# PGDATA, while a temporary server is running on the Unix socket (PGHOST is
# already exported and local auth is trust). Enable the pgvector extension in
# template1 (so every subsequently created database inherits it) and in the
# default database.
set -e

DBUSER="${POSTGRES_USER:-postgres}"
for DB in template1 "${POSTGRES_DB:-postgres}"; do
  echo "[pgvector] enabling vector extension in database: $DB"
  psql -v ON_ERROR_STOP=1 --username "$DBUSER" --dbname "$DB" \
    -c "CREATE EXTENSION IF NOT EXISTS vector;"
done
