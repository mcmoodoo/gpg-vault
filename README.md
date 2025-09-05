# Claude Code Podman Sandbox

A secure, isolated development environment for running Claude Code using Podman containers. This sandbox provides network isolation, resource limits, and file system security while maintaining seamless integration with your local development workflow.

## Quick Start

1. **Launch the sandbox:**
   ```bash
   ./sandbox.sh
   ```

2. **Load convenience functions:**
   ```bash
   source sandbox-functions.sh
   ```

3. **Use Claude Code:**
   ```bash
   sandbox_claude
   ```

## Features

- **Secure isolation:** Network disabled, capabilities dropped, read-only filesystem
- **Resource limits:** 2GB memory, 2 CPU cores
- **File ownership consistency:** Automatic UID/GID mapping
- **Rootless operation:** Uses Podman's rootless capabilities
- **Minimal footprint:** Lean Arch Linux base with only essential tools

## Files

- `Containerfile` - Container image definition with Arch Linux base
- `sandbox.sh` - Main launch script with security restrictions
- `sandbox-functions.sh` - Convenience functions for common operations

## Usage Examples

### Basic Workflow

```bash
# Start the sandbox
./sandbox.sh

# Load convenience functions
source sandbox-functions.sh

# Edit files with your local editor
vim myproject.py

# Run Claude Code in sandbox
sandbox_claude

# The changes are immediately visible on both host and container
```

### Available Commands

```bash
# Shell access
sandbox_shell

# Development tools
sandbox_python script.py
sandbox_node app.js  
sandbox_npm install package-name
sandbox_git status

# Execute any command
sandbox_exec ls -la
sandbox_exec tree

# Check status
sandbox_status

# Stop sandbox
sandbox_stop
```

## Security Features

- **Network isolation:** `--network=none` prevents internet access
- **Capability dropping:** `--cap-drop=ALL` removes unnecessary privileges
- **No privilege escalation:** `--security-opt=no-new-privileges`
- **Read-only filesystem:** Prevents container modifications
- **Resource limits:** Memory and CPU constraints
- **Minimal attack surface:** Only essential packages installed
- **User mapping:** Runs with your host UID/GID

## File Access

- Current directory is mounted to `/workspace` in the container
- Files created in the container have correct ownership on the host
- Changes are immediately synchronized between host and container
- Container cannot access other host directories

## Troubleshooting

**Container won't start:**
```bash
# Rebuild the image
podman rmi claude-sandbox
./sandbox.sh
```

**Permission issues:**
```bash
# Check user mapping
id
podman exec -it claude-sandbox-container id
```

**Network needed temporarily:**
```bash
# Stop current container
sandbox_stop

# Start with network (modify sandbox.sh temporarily)
# Change --network=none to --network=host
./sandbox.sh
```

## Customization

Edit `sandbox.sh` to modify:
- Resource limits (`--memory`, `--cpus`)
- Security restrictions
- Mount points
- Container name

Edit `Containerfile` to add packages:
```dockerfile
RUN pacman -S --noconfirm additional-package
```

## Requirements

- Podman installed and configured for rootless operation
- Current user in the `podman` group (if applicable)
- Sufficient disk space for container image (~500MB)