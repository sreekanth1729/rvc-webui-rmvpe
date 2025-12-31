#!/usr/bin/env bash
set -e

echo "=== LIST / ==="
ls -la /

echo "=== LIST /app ==="
ls -la /app || true

echo "=== FIND PY FILES ==="
find /app -maxdepth 4 -type f -name "*.py" | head -n 100 || true

echo "=== SLEEPING ==="
sleep infinity
