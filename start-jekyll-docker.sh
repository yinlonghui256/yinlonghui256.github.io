#!/usr/bin/env bash
# start-jekyll-docker.sh
# Run the site inside Docker (avoids installing Ruby in WSL)
# Usage: ./start-jekyll-docker.sh up|down|build|shell

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

COMPOSE_CMD="docker compose"
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found. Please install Docker Desktop / Docker Engine in WSL." >&2
  exit 2
fi

# prefer 'docker compose' (v2) but fallback to 'docker-compose' if needed
if ! $COMPOSE_CMD version >/dev/null 2>&1; then
  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
  else
    echo "docker compose or docker-compose not found." >&2
    exit 2
  fi
fi

case "${1-}" in
  up|start)
    echo "Building (if needed) and starting services..."
    $COMPOSE_CMD up --build
    ;;
  build)
    echo "Building services..."
    $COMPOSE_CMD build --no-cache
    ;;
  down|stop)
    echo "Stopping services..."
    $COMPOSE_CMD down
    ;;
  shell)
    echo "Opening shell in the jekyll service (interactive)..."
    # get service name from compose file; fallback to 'jekyll'
    SERVICE=jekyll
    $COMPOSE_CMD exec --user root "$SERVICE" /bin/bash
    ;;
  logs)
    $COMPOSE_CMD logs -f
    ;;
  *)
    cat <<EOF
Usage: $0 {up|build|down|shell|logs}

Commands:
  up      Build (if needed) and start the site (maps ports as in docker-compose.yml)
  build   Force rebuild the image
  down    Stop and remove containers
  shell   Open an interactive shell in the container (as root)
  logs    Follow container logs

Notes:
- The project directory will be mounted into the container, so changes are live.
- Ports: container maps 8080 (site) and 35729 (livereload) by default.
- If you run into permission issues, see docker-compose.yml comments about providing UID/GID build args.
EOF
    exit 1
    ;;
esac
