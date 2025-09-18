FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

ENV PYTHON_VERSION=3.12
ENV NODE_VERSION=v22.19.0

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

USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:/home/ubuntu/.bun/bin:/home/ubuntu/.nvm/versions/node/$NODE_VERSION/bin:$PATH"

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN uv python install $PYTHON_VERSION

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
RUN source /home/ubuntu/.nvm/nvm.sh && nvm install $NODE_VERSION

RUN curl -fsSL https://bun.sh/install | bash

CMD ["/bin/bash"]
