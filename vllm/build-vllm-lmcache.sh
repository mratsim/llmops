#!/bin/bash
# Build vLLM with LMCache
# ccache: podman build -v ./vllm-ccache:/root/.ccache -t vllm-202601-cu129 -f vllm-lmcache-Dockerfile

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_TAG=vllm-202601-cu129
UVCACHE_DIR=$SCRIPT_DIR/"vllm-uvcache"
CCACHE_DIR=$SCRIPT_DIR/"vllm-ccache"
TMPDIR=$SCRIPT_DIR/"vllm-dockercache"

mkdir -p "${UVCACHE_DIR}"
mkdir -p "${CCACHE_DIR}"
mkdir -p "${TMPDIR}"

TMPDIR="${TMPDIR}" podman build \
    -v "${UVCACHE_DIR}":/root/.cache/uv \
    -v "${CCACHE_DIR}":/root/.ccache \
    -t ${IMAGE_TAG} \
    -f vllm-lmcache-Dockerfile \
    "$@"
