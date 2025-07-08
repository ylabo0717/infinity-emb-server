# infinity

Setup and execution environment for Infinity Embedding server.

## Overview

This project provides an environment to run an embedding API server locally using [infinity-emb](https://github.com/michaelfeil/infinity). It uses the `cl-nagoya/ruri-v3-310m` model, which is specialized for Japanese text embeddings.

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

To start the embedding server, run the following command:

```bash
./start_infinity.sh
```

Or run directly:

```bash
uv run infinity_emb v2 \
    --model-id cl-nagoya/ruri-v3-310m \
    --host 0.0.0.0 --port 7997 \
    --batch-size 128 \
    --engine torch \
    --device mps \
    --url-prefix /v1
```

The server will start at `http://localhost:7997` as an OpenAI-compatible API.

## Example Request

You can test the server with a sample request using `curl`:

```bash
curl http://localhost:7997/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"cl-nagoya/ruri-v3-310m","input":["瑠璃色とは？"]}'
```

The response will contain the embeddings for the input text in JSON format.

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


## Configuration

- **Model**: cl-nagoya/ruri-v3-310m (Japanese embedding model)
- **Port**: 7997
- **Batch size**: 128
- **Engine**: PyTorch
- **Device**: MPS (macOS)
- **API format**: OpenAI-compatible

## Main Dependencies

- infinity-emb[all]: Embedding server
- torch, torchaudio, torchvision: PyTorch-related
- transformers: Hugging Face Transformers
- sentencepiece: Tokenizer
