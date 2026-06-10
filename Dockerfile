FROM node:22-bookworm-slim

# Tools Claude Code relies on: git for VCS, ripgrep for fast search, plus basics.
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        ripgrep \
        ca-certificates \
        curl \
        less \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code globally.
RUN npm install -g @anthropic-ai/claude-code

# Quieter, more predictable behavior inside a container: no telemetry, no
# auto-updates churning the image at runtime.
ENV CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    DISABLE_AUTOUPDATER=1

# Run as the image's built-in non-root user. Pre-create the config dir so the
# named volume mounted there is owned by `node` (not root) on first run.
RUN mkdir -p /home/node/.claude && chown -R node:node /home/node/.claude
USER node

WORKDIR /workspace

CMD ["claude"]
