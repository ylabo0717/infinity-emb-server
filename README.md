# infinity

Setup and execution environment for Infinity Embedding and Reranking servers.

## Overview

This project provides an environment to run embedding and reranking API servers locally using [infinity-emb](https://github.com/michaelfeil/infinity). It runs two servers:

1. **Embedding server** (port 7997): Uses `cl-nagoya/ruri-v3-310m` model for Japanese text embeddings
2. **Reranker server** (port 7998): Uses `cl-nagoya/ruri-v3-reranker-310m` model for Japanese text reranking

## Requirements

- Python 3.12 or higher
- uv (Python package manager)
- For macOS: MPS (Metal Performance Shaders) compatible device

## Setup

1. Install dependencies:

```bash
uv sync
```

## Usage

### Starting the servers

To start both embedding and reranking servers:

```bash
./start_infinity.sh
```

This will start:
- Embedding server at `http://localhost:7997`
- Reranker server at `http://localhost:7998`

Both servers provide OpenAI-compatible APIs.

### Stopping the servers

```bash
./start_infinity.sh stop
```

### Log files

Server logs are written to:
- `./logs/infinity-emb.log` (embedding server)
- `./logs/infinity-rerank.log` (reranker server)

## Example Requests

### Embedding API

```bash
curl http://localhost:7997/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"cl-nagoya/ruri-v3-310m","input":["瑠璃色とは？"]}'
```

Response:
```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "index": 0,
      "embedding": [-0.00699, 0.10441, -0.00097, ..., 0.03522]
    }
  ],
  "model": "cl-nagoya/ruri-v3-310m",
  "usage": {"prompt_tokens": 6, "total_tokens": 6},
  "id": "infinity-5741844e-fa83-4f1c-a8cb-57226767b77b",
  "created": 1751905859
}
```

### Reranker API

```bash
curl http://localhost:7998/v1/rerank \
  -H "Content-Type: application/json" \
  -d '{
    "model": "cl-nagoya/ruri-v3-reranker-310m",
    "query": "瑠璃色とは何ですか？",
    "documents": [
      "瑠璃色は青色の一種です",
      "瑠璃色は深い青色を指します",
      "緑色は植物の色です"
    ]
  }'
```


## Configuration

### Embedding Server
- **Model**: cl-nagoya/ruri-v3-310m (Japanese embedding model)
- **Port**: 7997
- **Batch size**: 128
- **Device**: MPS (macOS) / CUDA / CPU
- **API endpoint**: `/v1/embeddings`

### Reranker Server
- **Model**: cl-nagoya/ruri-v3-reranker-310m (Japanese reranker model)
- **Port**: 7998
- **Batch size**: 1
- **Device**: MPS (macOS) / CUDA / CPU
- **API endpoint**: `/v1/rerank`

### Device Configuration
By default, the script uses MPS for Apple Silicon. You can change the device in `start_infinity.sh`:
- `DEVICE="mps"` for Apple Silicon GPU
- `DEVICE="cuda"` for NVIDIA GPU
- `DEVICE="cpu"` for CPU-only mode

## Main Dependencies

- infinity-emb[all]: Embedding and reranking server framework
- torch, torchaudio, torchvision: PyTorch-related
- transformers: Hugging Face Transformers
- sentencepiece: Tokenizer
- fugashi: Japanese morphological analyzer
