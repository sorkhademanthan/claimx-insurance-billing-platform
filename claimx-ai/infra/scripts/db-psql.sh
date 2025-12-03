#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./infra/scripts/db-psql.sh             -> default list tables (psql -c '\dt')
#   ./infra/scripts/db-psql.sh "SELECT 1;" -> executes SQL
# This script will:
#  - find a running postgres container (tries image 'postgres:15' or 'postgres')
#  - read POSTGRES_USER / POSTGRES_PASSWORD environment variables from container config
#  - run psql inside the container using the extracted password (or without if not present)

SQL=${*:-"\dt"}

# Find postgres container: try exact tag first, else any postgres ancestor image
container_id=$(docker ps -q -f "ancestor=postgres:15" || true)
if [ -z "$container_id" ]; then
  container_id=$(docker ps -q -f "ancestor=postgres" || true)
fi

if [ -z "$container_id" ]; then
  echo "No running PostgreSQL container found. Make sure the infra is up (docker compose up -d)."
  exit 1
fi

# Extract env values
envs=$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' "$container_id" || true)
PG_USER=$(echo "$envs" | grep '^POSTGRES_USER=' | cut -d '=' -f2 || echo "claimx")
PG_PASSWORD=$(echo "$envs" | grep '^POSTGRES_PASSWORD=' | cut -d '=' -f2 || true)

echo "Using container: $container_id (user: ${PG_USER})"

# Try to run psql inside the container with PGPASSWORD if present
if [ -n "$PG_PASSWORD" ]; then
  echo "Detected POSTGRES_PASSWORD env in container. Running psql with that password."
  # Use PGPASSWORD only for this single psql invocation
  docker exec -i "$container_id" bash -lc "PGPASSWORD='$PG_PASSWORD' psql -U '$PG_USER' -d claimx_dev -c \"$SQL\""
else
  echo "No POSTGRES_PASSWORD found in container env. Running psql without password (container local access)."
  docker exec -it "$container_id" psql -U "$PG_USER" -d claimx_dev -c "$SQL"
fi
