#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="infra/docker/docker-compose.dev.yml"
POSTGRES_HOST_PORT="${POSTGRES_HOST_PORT:-5432}"
MINIO_HOST_PORT="${MINIO_HOST_PORT:-9000}"
PGADMIN_HOST_PORT="${PGADMIN_HOST_PORT:-8081}"
KAFKA_HOST_PORT="${KAFKA_HOST_PORT:-9092}"

echo "Checking Docker connectivity..."
if ! docker info >/dev/null 2>&1; then
  echo "Docker does not appear to be running. Start Docker Desktop / Engine and re-run this script."
  exit 1
fi

echo "Checking whether host ports are available (postgres:$POSTGRES_HOST_PORT, minio:$MINIO_HOST_PORT, pgadmin:$PGADMIN_HOST_PORT, kafka:$KAFKA_HOST_PORT)..."
# macOS/Linux: use lsof if available, else fallback to nc test
port_in_use() {
  local port=$1
  if command -v lsof >/dev/null 2>&1; then
    lsof -iTCP:"$port" -sTCP:LISTEN -n -P >/dev/null 2>&1
    return $?
  else
    if command -v nc >/dev/null 2>&1; then
      nc -z localhost "$port" >/dev/null 2>&1
      return $?
    fi
    return 1
  fi
}

if port_in_use "$POSTGRES_HOST_PORT"; then
  echo "ERROR: Port $POSTGRES_HOST_PORT is already in use on the host."
  echo "Check whether a Docker container is using the port: docker ps --filter 'publish=$POSTGRES_HOST_PORT' --format 'table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Ports}}'"
  echo "If a container is using the port, stop it: docker stop <container-id-or-name>"
  echo "If a local process is using the port, find it with: lsof -iTCP:$POSTGRES_HOST_PORT -sTCP:LISTEN -n -P"
  echo "Stop local DB if appropriate (macOS): brew services stop postgresql"
  echo "Or run with alternate port: POSTGRES_HOST_PORT=5433 ./infra/scripts/bootstrap.sh"
  exit 1
fi

if port_in_use "$MINIO_HOST_PORT"; then
  echo "WARNING: MinIO host port $MINIO_HOST_PORT is in use; you may change MINIO_HOST_PORT similarly."
fi

if port_in_use "$PGADMIN_HOST_PORT"; then
  echo "WARNING: PgAdmin host port $PGADMIN_HOST_PORT is in use; change PGADMIN_HOST_PORT or stop local pgadmin."
fi

if port_in_use "$KAFKA_HOST_PORT"; then
  echo "WARNING: Kafka host port $KAFKA_HOST_PORT is in use; change KAFKA_HOST_PORT or stop the process."
fi

echo "Pre-pulling docker images..."
if ! docker compose -f "$COMPOSE_FILE" pull; then
  echo "Warning: Some images failed to pull. See logs and consider 'docker login' or updating the compose file."
fi

echo "Starting local dev infra (Postgres, Kafka [Confluent], MinIO, PgAdmin)..."
if ! docker compose -f "$COMPOSE_FILE" up -d; then
  echo "Failed to start some services. Check docker compose logs for details:"
  echo "  docker compose -f $COMPOSE_FILE logs --tail=200"
  exit 1
fi

echo "Verifying containers are running..."
docker compose -f "$COMPOSE_FILE" ps

# Wait for Postgres to be ready
postgres_container_id=$(docker ps -q -f "ancestor=postgres:15" | head -n1 || true)
if [ -n "$postgres_container_id" ]; then
  until docker exec -i "$postgres_container_id" pg_isready -U claimx >/dev/null 2>&1; do
    sleep 1
  done
  echo "Postgres is ready."
else
  echo "Postgres container not found; check docker-compose logs"
fi

# Wait for Kafka (9092) to be reachable
kafka_container_id=$(docker ps -q -f "ancestor=confluentinc/cp-kafka" | head -n1 || true)
if [ -n "$kafka_container_id" ]; then
  echo "Waiting for Kafka at $KAFKA_HOST_PORT (may require 10-60 seconds to be ready)..."
  timeout=60
  while [ $timeout -gt 0 ]; do
    if nc -z localhost "$KAFKA_HOST_PORT" >/dev/null 2>&1; then
      echo "Kafka broker port is listening."
      break
    fi
    sleep 1
    timeout=$((timeout - 1))
  done
  if [ $timeout -le 0 ]; then
    echo "Kafka didn't start listening on $KAFKA_HOST_PORT in time; check docker logs for kafka."
  fi
else
  echo "Kafka container not found; check docker-compose logs; if you don't need a broker replace 'kafka' with a cloud broker in .env."
fi

echo "Ensured infra is up. Ensuring apps/ and libs/ directories exist..."
mkdir -p apps libs

echo "Next steps (suggested):"
echo "1) Generate apps into the apps/ directory (keeps workspace consistent):"
echo "   npx nx g @nx/nest:application claim-service --directory=apps"
echo "   npx nx g @nx/react:application claim-dashboard --directory=apps --style=css"
echo ""
echo "2) If you already created apps at workspace root, run the helper to move them (infra/scripts/move-apps-to-apps.sh):"
echo "   chmod +x infra/scripts/move-apps-to-apps.sh && ./infra/scripts/move-apps-to-apps.sh claim-service claim-dashboard"
echo ""
echo "3) To inspect logs if something failed:"
echo "   docker compose -f $COMPOSE_FILE logs --tail=200"
echo "   docker compose -f $COMPOSE_FILE ps"
echo ""
echo "Note: Use the provided .env.example to populate your env vars."
