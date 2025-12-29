#!/bin/bash
set -e

# Configuration
REPO=$REPO
ACCESS_TOKEN=$TOKEN
RUNNER_NAME=$RUNNER_NAME
LABELS=$LABELS

# Validate required environment variables
if [ -z "$REPO" ] || [ -z "$ACCESS_TOKEN" ] || [ -z "$RUNNER_NAME" ]; then
    echo "ERROR: Missing required environment variables"
    echo "Required: REPO, TOKEN, RUNNER_NAME"
    exit 1
fi

echo "Starting GitHub Actions Runner registration..."
echo "Repository: $REPO"
echo "Runner Name: $RUNNER_NAME"
echo "Labels: $LABELS"

# Get registration token from GitHub API
echo "Fetching registration token from GitHub..."
REG_TOKEN=$(curl -sX POST \
    -H "Authorization: token ${ACCESS_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output)

if [ -z "$REG_TOKEN" ] || [ "$REG_TOKEN" == "null" ]; then
    echo "ERROR: Failed to retrieve registration token"
    echo "Check your TOKEN and REPO values"
    exit 1
fi

echo "Registration token obtained successfully"

cd /home/docker/actions-runner

# Configure the runner
echo "Configuring runner..."
./config.sh --url https://github.com/${REPO} \
    --token ${REG_TOKEN} \
    --name ${RUNNER_NAME} \
    --labels ${LABELS} \
    --unattended

# Cleanup function
cleanup() {
    echo "Received shutdown signal, cleaning up..."
    
    # Prune Docker resources
    docker system prune -f || true
    
    # Get new token for deregistration
    echo "Removing runner from GitHub..."
    REMOVE_TOKEN=$(curl -sX POST \
        -H "Authorization: token ${ACCESS_TOKEN}" \
        -H "Accept: application/vnd.github+json" \
        https://api.github.com/repos/${REPO}/actions/runners/remove-token | jq .token --raw-output)
    
    if [ -n "$REMOVE_TOKEN" ] && [ "$REMOVE_TOKEN" != "null" ]; then
        ./config.sh remove --token ${REMOVE_TOKEN} || true
        echo "Runner removed successfully"
    else
        echo "WARNING: Failed to retrieve removal token"
    fi
}

# Set up signal handlers
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Start the runner
echo "Starting runner..."
./run.sh & wait $!