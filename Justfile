#!/usr/bin/env just

# Variables
image_name := "pass-sandbox"
user_id := `id -u`
group_id := `id -g`
current_dir := `pwd`

# Default recipe - show available commands
default:
    @just --list

# Build the sandbox container image
build:
    podman build \
        --build-arg USER_ID={{user_id}} \
        --build-arg GROUP_ID={{group_id}} \
        -t {{image_name}} .

# Start the sandbox container
start:
    podman run -d \
        --name {{image_name}}-container \
        --user {{user_id}}:{{group_id}} \
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
        --volume {{current_dir}}:/workspace:Z \
        {{image_name}} \
        sleep infinity

# Connect to the running container with shell access
shell:
    podman exec -it {{image_name}}-container /bin/bash

stop:
    podman stop {{image_name}}-container

remove:
    podman rm {{image_name}}-container
