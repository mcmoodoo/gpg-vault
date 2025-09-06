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
        --userns=keep-id \
        --env HOME=/home/mcmoodoo \
        --network=none \
        --cap-drop=ALL \
        --security-opt=no-new-privileges \
        --memory=2g \
        --cpus=2 \
        --read-only \
        --tmpfs /tmp:rw,noexec,nosuid,size=100m \
        --tmpfs /var/tmp:rw,noexec,nosuid,size=100m \
        --tmpfs /home/mcmoodoo/.cache:rw,size=100m \
        --tmpfs /home/mcmoodoo/.npm:rw,size=100m \
        --volume {{current_dir}}:/workspace \
        {{image_name}} \
        sleep infinity

# Connect to the running container with shell access
shell:
    podman exec -it {{image_name}}-container /bin/bash

stop:
    podman stop {{image_name}}-container

remove:
    podman rm {{image_name}}-container

# Decrypt age-encrypted file from age directory to decrypted directory
decrypt encrypted-file="./encrypted/gpg-private-keys.tar.age":
    @mkdir -p .gnupg
    @mkdir -p decrypted
    age -d -o decrypted/gpg-private-keys.tar {{encrypted-file}} 
    tar -xf decrypted/gpg-private-keys.tar -C .gnupg/
    shred decrypted/gpg-private-keys.tar

encrypt private_keys="~/.gnupg/private-keys-v1.d/":
    @mkdir -p encrypted
    tar -cf gpg-private-keys.tar {{private_keys}}
    age -p -o encrypted/gpg-private-keys.tar.age gpg-private-keys.tar
    shred -u gpg-private-keys.tar
