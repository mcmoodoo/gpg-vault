# Claude Code Podman Sandbox Setup

Create a complete Podman-based development sandbox for running Claude Code safely. The sandbox should allow me to use my local editor while having Claude Code run in an isolated container that can only modify files in my current project directory.

## Requirements

1. **Create a Containerfile** (Podman's Dockerfile equivalent) that:

   - Uses archlinux:latest as base image
   - Uses pacman to install common development tools (git, curl, vim, python, base-devel, jq, tree, nodejs, npm)
   - Installs Claude Code via npm
   - Creates a user with configurable UID/GID to match host user
   - Sets up proper working directory

2. **Create a sandbox launch script** (`sandbox.sh`) that:

   - Uses Podman commands exclusively (podman build, podman run, etc.)
   - Builds the container image if it doesn't exist using `podman build`
   - Stops and removes any existing sandbox container using `podman stop/rm`
   - Runs the container with Podman-specific security restrictions:
     - Mount current directory to /workspace using Podman volume syntax
     - Use host user ID/GID for file ownership consistency (`--user $(id -u):$(id -g)`)
     - Disable network access with `--network=none`
     - Drop unnecessary capabilities with `--cap-drop=ALL`
     - Use security options like `--security-opt=no-new-privileges`
     - Set memory and CPU limits using Podman resource flags
     - Use read-only root filesystem with necessary tmpfs mounts
   - Provides clear usage instructions for Podman commands

3. **Create convenience aliases/functions** for:

   - Connecting to sandbox bash shell using `podman exec`
   - Running Claude Code directly in sandbox with `podman exec`
   - Stopping the sandbox using `podman stop`
   - Running other development commands (python, npm, etc.) via `podman exec`

4. **Add a usage example** showing the Podman-based workflow:
   - Edit files locally with preferred editor
   - Use Claude Code in Podman container
   - See changes immediately on host
   - Maintain proper file ownership with Podman user mapping

## Security Goals

- Podman container can only modify files in mounted project directory
- No access to host system files
- Network isolation using `--network=none`
- Resource limits using Podman resource flags
- Rootless Podman execution for enhanced security
- Use Podman's built-in security features

## Usability Goals

- One `podman run` command to start sandbox
- Seamless file synchronization between host and Podman container
- Consistent file ownership using Podman user mapping
- Easy access to Claude Code and other development tools via `podman exec`
- Works with existing local development workflow
- Leverage Podman's rootless capabilities

## Podman-Specific Features to Use

- Use `podman build` instead of docker build
- Use `podman run` with Podman-specific security options
- Take advantage of Podman's rootless operation
- Use Podman volume mounting syntax
- Include Podman-specific resource and security flags

Please implement this complete Podman-based solution with all necessary files and clear documentation using Podman commands throughout. Keep it lean to avoid unnecessarily large image size.
