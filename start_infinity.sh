#!/usr/bin/env bash
#
# start_infinity.sh
#
# This script starts two Infinity servers:
#   1. Embedding server   : cl-nagoya/ruri-v3-310m   (port 7997)
#   2. Reranker server    : cl-nagoya/e5-ja-reranker-large (port 7998)
#
# Requirements:
#   - The virtual environment stored in $VENV must contain infinity-emb and its dependencies.
#   - Adjust DEVICE to "mps", "cuda", or "cpu" depending on your hardware.
#
# Usage:
#   chmod +x start_infinity.sh
#   ./start_infinity.sh           # start both servers
#   ./start_infinity.sh stop      # stop both servers
#
# Log files are written to $HOME/logs.
#

# ------------- Configuration -------------
EMB_PORT=7997                     # Port for the embedding server
RERANK_PORT=7998                  # Port for the reranker server
DEVICE="mps"                      # "mps" for Apple GPU, "cuda" for NVIDIA, "cpu" for CPU-only

# ------------- Functions -------------
start_servers() {

  # Start embedding server
  uv run infinity_emb v2 \
    --model-id cl-nagoya/ruri-v3-310m \
    --host 0.0.0.0 --port "$EMB_PORT" \
    --batch-size 128 \
    --device "$DEVICE" \
    --url-prefix /v1 \
    > "./logs/infinity-emb.log" 2>&1 &
  EMB_PID=$!

  # Start reranker server
  uv run infinity_emb v2 \
    --model-id cl-nagoya/ruri-v3-reranker-310m \
    --host 0.0.0.0 --port "$RERANK_PORT" \
    --batch-size 1 \
    --device "$DEVICE" \
    --url-prefix /v1 \
    > "./logs/infinity-rerank.log" 2>&1 &
  RERANK_PID=$!

  echo "$EMB_PID" > /tmp/infinity_emb.pid
  echo "$RERANK_PID" > /tmp/infinity_rerank.pid

  echo "Embedding server   : http://localhost:$EMB_PORT/v1/embeddings"
  echo "Reranker server    : http://localhost:$RERANK_PORT/v1/rerank"
  echo "Press Ctrl-C to stop or run './start_infinity.sh stop'"
  wait
}

stop_servers() {
  for f in /tmp/infinity_{emb,rerank}.pid; do
    if [ -f "$f" ]; then
      kill "$(cat "$f")" && rm "$f"
    fi
  done
  echo "Infinity servers stopped"
}

# ------------- Main -------------
case "$1" in
  stop) stop_servers ;;
  *)    start_servers ;;
esac
