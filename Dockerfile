FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

ENV PYTHON_VERSION=3.12
ENV NODE_VERSION=v22.19.0
ENV PATH="/root/.local/bin:/root/.bun/bin:/root/.nvm/versions/node/$NODE_VERSION/bin:$PATH"

# Update package list and install essential packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    wget \
    build-essential \
    git \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN uv python install $PYTHON_VERSION && uv python pin $PYTHON_VERSION

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
RUN source /root/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION

RUN curl -fsSL https://bun.sh/install | bash

CMD ["/bin/bash"]
