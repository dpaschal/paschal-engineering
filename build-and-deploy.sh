#!/bin/bash
# Build and deploy documentation
# Usage: ./build-and-deploy.sh [dev|prod]

set -e

ENVIRONMENT=${1:-dev}
REPO_DIR="/data/appdata/paschal-engineering"

cd "$REPO_DIR"

# Checkout appropriate branch
if [ "$ENVIRONMENT" = "prod" ]; then
    git checkout main
    git pull origin main
    CONTAINER_NAME="docs-prod"
    IMAGE_TAG="docs:prod"
else
    git checkout dev
    git pull origin dev
    CONTAINER_NAME="docs-dev"
    IMAGE_TAG="docs:dev"
fi

echo "Building MkDocs site for $ENVIRONMENT..."

# Build the Docker image
podman build -t "$IMAGE_TAG" -f Dockerfile.docs .

# Stop and remove old container if it exists
podman stop "$CONTAINER_NAME" 2>/dev/null || true
podman rm "$CONTAINER_NAME" 2>/dev/null || true

echo "Deployment complete for $ENVIRONMENT"
echo "Container will be started via podman-compose"
