FROM ubuntu:22.04

ARG RUNNER_VERSION="2.323.0"
ARG DOCKER_COMPOSE_VERSION="v2.24.0"
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKER_GID

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip \
    ca-certificates gnupg lsb-release software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh
RUN chown -R docker:docker /home/docker

RUN usermod -aG docker docker && \
    mkdir -p /var/run && \
    touch /var/run/docker.sock && \
    chown root:docker /var/run/docker.sock && \
    chmod 660 /var/run/docker.sock

RUN groupmod -g ${DOCKER_GID} docker

WORKDIR /home/docker

COPY --chown=docker:docker start.sh /home/docker/start.sh

RUN chmod +x /home/docker/start.sh && \
    sed -i 's/\r$//' /home/docker/start.sh

USER docker

ENTRYPOINT ["/home/docker/start.sh"]