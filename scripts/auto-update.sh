#!/bin/bash

# Auto-update script for Docker containers
# Run this via cron to check for and deploy new images
#
# To set up cron (runs every 6 hours):
# 0 */6 * * * /path/to/scripts/auto-update.sh >> /var/log/auto-update.log 2>&1

set -e

# Base directory where docker-compose files are located
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "$(date): Checking for container updates..."

# Update rule-book-backend
echo "Checking rule-book-backend..."
cd "$BASE_DIR/rule-book"
docker compose pull rule-book-backend
docker compose up -d rule-book-backend

# Update high-five-me-backend
echo "Checking high-five-me-backend..."
cd "$BASE_DIR/high-five-me"
docker compose pull backend
docker compose up -d backend

# Clean up old images
docker image prune -f

echo "$(date): Update check complete"
