#!/usr/bin/env bash
# ~/bin/pi - Run oh-my-pi in a sandboxed container
set -euo pipefail

POD_NAME="oh-my-pi"
PI_IMAGE="oh-my-pi-202604:latest"
PI_AGENT_DIR="${HOME}/.omp/agent"

mkdir -p "${PI_AGENT_DIR}"

# Write models.yml (always overwrite)
cat > "${PI_AGENT_DIR}/models.yml" << 'EOFMODELS'
providers:
  tabbyapi:
    baseUrl: http://host.containers.internal:5000/v1
    api: openai-completions
    auth: none
    models:
      - id: Qwen3.5-397B-A17B
        name: Qwen3.5-397B-A17B (TabbyAPI)
        reasoning: true
        input: [text, image]
        cost:
          input: 0
          output: 0
          cacheRead: 0
          cacheWrite: 0
        contextWindow: 524288
        maxTokens: 81920

  ik-llama:
    baseUrl: http://host.containers.internal:4000/v1
    api: openai-completions
    auth: none
    models:
      - id: Qwen3.5-397B-A17B
        name: Qwen3.5-397B-A17B (ik-llama)
        reasoning: true
        input: [text, image]
        cost:
          input: 0
          output: 0
          cacheRead: 0
          cacheWrite: 0
        contextWindow: 262144
        maxTokens: 81920

  sglang:
    baseUrl: http://host.containers.internal:2000/v1
    api: openai-completions
    auth: none
    models:
      - id: MiniMax-M2.5
        name: MiniMax-M2.5 (SGLang)
        reasoning: true
        input: [text]
        cost:
          input: 0
          output: 0
          cacheRead: 0
          cacheWrite: 0
        contextWindow: 196608
        maxTokens: 131072

  vllm:
    baseUrl: http://host.containers.internal:2000/v1
    api: openai-completions
    auth: none
    models:
      - id: Qwen3.6-35B-A3B
        name: Qwen3.6-35B-A3B (vLLM)
        reasoning: true
        input: [text, image]
        cost:
          input: 0
          output: 0
          cacheRead: 0
          cacheWrite: 0
        contextWindow: 262144
        maxTokens: 81920

      - id: Qwen3.6-27B
        name: Qwen3.6-27B (vLLM)
        reasoning: true
        input: [text, image]
        cost:
          input: 0
          output: 0
          cacheRead: 0
          cacheWrite: 0
        contextWindow: 262144
        maxTokens: 81920

      - id: Nemotron-3-Super
        name: Nemotron-3-Super (vLLM)
        reasoning: true
        input: [text]
        cost:
          input: 0
          output: 0
          cacheRead: 0
          cacheWrite: 0
        contextWindow: 1048576
        maxTokens: 262144
EOFMODELS

# Map container UID 0 to our host UID
# uid=$(id -u)
# gid=$(id -g)
# subuidSize=$(( $(podman info --format "{{ range .Host.IDMappings.UIDMap }}+{{.Size }}{{end }}" ) - 1 ))
# subgidSize=$(( $(podman info --format "{{ range .Host.IDMappings.GIDMap }}+{{.Size }}{{end }}" ) - 1 ))

# Create pod (skip UID mapping, very slow)
# And mapping ID 1000 to us has no alternative that work (userns=keepid also freezes)
# So unfortunately we have to have root user within the container
podman pod create --replace \
    --name "${POD_NAME}_pod"

    # --uidmap "$uid:0:1" --uidmap "0:1:$uid" --uidmap "$((uid+1)):$((uid+1)):$((subuidSize-uid))" \
    # --gidmap "$gid:0:1" --gidmap "0:1:$gid" --gidmap "$((gid+1)):$((gid+1)):$((subgidSize-gid))" \

# Run container in pod
podman run --replace --rm \
    --tty --interactive \
    --name "${POD_NAME}" \
    --pod "${POD_NAME}_pod" \
    --cap-drop=ALL \
    --security-opt=no-new-privileges \
    --cgroupns=private \
    --uts=private \
    --volume "$(pwd):$(pwd)" \
    --volume "${PI_AGENT_DIR}:/omp-agent" \
    --env PI_STREAM_FIRST_EVENT_TIMEOUT_MS=600000 \
    --env PI_CODING_AGENT_DIR=/omp-agent \
    --workdir "$(pwd)" \
    --env "TERM=${TERM:-xterm-256color}" \
    --env "COLORTERM=${COLORTERM:-truecolor}" \
    "${PI_IMAGE}" "$@"

    # idmap mount fail due o some permission issue
    # --mount type=bind,src="${PI_AGENT_DIR}",target=/omp-agent,idmap="uids=1000-${uid}-1;gids=1000-${gid}-1" \
    # --mount type=bind,src="$(pwd)",target="$(pwd)",idmap="uids=1000-${uid}-1;gids=1000-${gid}-1" \
