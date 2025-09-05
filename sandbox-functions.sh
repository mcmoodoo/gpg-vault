#!/bin/bash

CONTAINER_NAME="claude-sandbox-container"

sandbox_shell() {
    echo "Connecting to sandbox shell..."
    podman exec -it ${CONTAINER_NAME} /bin/bash
}

sandbox_claude() {
    echo "Starting Claude Code in sandbox..."
    podman exec -it ${CONTAINER_NAME} claude-code "$@"
}

sandbox_stop() {
    echo "Stopping sandbox..."
    podman stop ${CONTAINER_NAME}
}

sandbox_python() {
    echo "Running Python in sandbox..."
    podman exec -it ${CONTAINER_NAME} python "$@"
}

sandbox_node() {
    echo "Running Node.js in sandbox..."
    podman exec -it ${CONTAINER_NAME} node "$@"
}

sandbox_npm() {
    echo "Running npm in sandbox..."
    podman exec -it ${CONTAINER_NAME} npm "$@"
}

sandbox_git() {
    echo "Running git in sandbox..."
    podman exec -it ${CONTAINER_NAME} git "$@"
}

sandbox_exec() {
    echo "Executing command in sandbox: $@"
    podman exec -it ${CONTAINER_NAME} "$@"
}

sandbox_status() {
    if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "Sandbox is running"
        podman ps --filter name=${CONTAINER_NAME} --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo "Sandbox is not running"
    fi
}

sandbox_help() {
    echo "Claude Code Podman Sandbox Functions"
    echo "===================================="
    echo ""
    echo "Available functions:"
    echo "  sandbox_shell     - Connect to sandbox bash shell"
    echo "  sandbox_claude    - Run Claude Code in sandbox"
    echo "  sandbox_stop      - Stop the sandbox container"
    echo "  sandbox_python    - Run Python in sandbox"
    echo "  sandbox_node      - Run Node.js in sandbox"
    echo "  sandbox_npm       - Run npm in sandbox"
    echo "  sandbox_git       - Run git in sandbox"
    echo "  sandbox_exec      - Execute any command in sandbox"
    echo "  sandbox_status    - Check if sandbox is running"
    echo "  sandbox_help      - Show this help message"
    echo ""
    echo "Usage examples:"
    echo "  sandbox_claude --help"
    echo "  sandbox_python script.py"
    echo "  sandbox_npm install package-name"
    echo "  sandbox_git status"
    echo "  sandbox_exec ls -la"
}

echo "Sandbox functions loaded. Type 'sandbox_help' for usage information."