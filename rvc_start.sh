#!/usr/bin/env bash
set -euo pipefail

# ---- Path validation (fail loud) ----
if [ ! -d "/app/rvc" ]; then
  echo "CRITICAL ERROR: /app/rvc directory not found!"
  ls -la /app || true
  exit 1
fi

export PYTORCH_CUDA_ALLOC_CONF="${PYTORCH_CUDA_ALLOC_CONF:-max_split_size_mb:128}"
export PYTHONUNBUFFERED=1

mkdir -p /workspace/logs /var/log

# FileBrowser
/usr/local/bin/filebrowser -r /workspace -a 0.0.0.0 -p 8080 --noauth \
  > /var/log/filebrowser.log 2>&1 &

# TensorBoard
tensorboard --logdir /workspace/logs --port 6006 --host 0.0.0.0 \
  > /var/log/tensorboard.log 2>&1 &

cd /app/rvc
exec python infer-web.py --port 7865 --host 0.0.0.0
