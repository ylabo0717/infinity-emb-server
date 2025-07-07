uv run infinity_emb v2 \
    --model-id cl-nagoya/ruri-v3-310m \
    --host 0.0.0.0 --port 7997 \
    --batch-size 128 \
    --engine torch \
    --device mps \
    --url-prefix /v1
