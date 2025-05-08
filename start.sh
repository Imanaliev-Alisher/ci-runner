#!/bin/bash

REPO=$REPO
ACCESS_TOKEN=$TOKEN
RUNNER_NAME=$RUNNER_NAME
LABELS=$LABELS

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

./config.sh --url https://github.com/${REPO} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels ${LABELS}

cleanup() {
echo "Removing runner..."
    docker system prune -f
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!