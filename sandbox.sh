#!/bin/bash

set -e

IMAGE_NAME="claude-sandbox"
CONTAINER_NAME="claude-sandbox-container"

USER_ID=$(id -u)
GROUP_ID=$(id -g)
CURRENT_DIR=$(pwd)

echo "Claude Code Podman Sandbox"
echo "========================="

build_image() {
    echo "Building sandbox image..."
    podman build --build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID} -t ${IMAGE_NAME} .
}

cleanup_container() {
    if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "Stopping and removing existing container..."
        podman stop ${CONTAINER_NAME} 2>/dev/null || true
        podman rm ${CONTAINER_NAME} 2>/dev/null || true
    fi
}

start_sandbox() {
    echo "Starting sandbox container..."
    podman run -d \
        --name ${CONTAINER_NAME} \
        --user ${USER_ID}:${GROUP_ID} \
        --network=none \
        --cap-drop=ALL \
        --security-opt=no-new-privileges \
        --memory=2g \
        --cpus=2 \
        --read-only \
        --tmpfs /tmp:rw,noexec,nosuid,size=100m \
        --tmpfs /var/tmp:rw,noexec,nosuid,size=100m \
        --tmpfs /home/claudeuser/.cache:rw,size=100m \
        --tmpfs /home/claudeuser/.npm:rw,size=100m \
        --volume ${CURRENT_DIR}:/workspace:Z \
        ${IMAGE_NAME} \
        sleep infinity

    echo "Sandbox container started: ${CONTAINER_NAME}"
}

if ! podman image exists ${IMAGE_NAME}; then
    build_image
fi

cleanup_container
start_sandbox

echo ""
echo "Sandbox is ready!"
echo ""
echo "Usage:"
echo "  Shell access:    podman exec -it ${CONTAINER_NAME} /bin/bash"
echo "  Claude Code:     podman exec -it ${CONTAINER_NAME} claude-code"
echo "  Stop sandbox:    podman stop ${CONTAINER_NAME}"
echo "  Python:          podman exec -it ${CONTAINER_NAME} python"
echo "  Node.js:         podman exec -it ${CONTAINER_NAME} node"
echo ""
echo "Files in ${CURRENT_DIR} are mounted to /workspace in the container."
