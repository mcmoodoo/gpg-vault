#!/usr/bin/env just

# Variables
current_dir := `pwd`

# Default recipe - show available commands
default:
    @just --list

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

# Ubuntu container recipes

# Start Ubuntu container with dedicated user
start:
    podman run -d \
        --name ubuntu-box \
        --volume {{current_dir}}/.gnupg:/home/user/.gnupg \
        --volume {{current_dir}}/password-store:/home/user/.password-store \
        ubuntu:latest \
        sh -c 'apt-get update && apt-get install -y pass sudo && useradd -m -s /bin/bash user && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && sleep infinity'

# Shell into Ubuntu container as user
shell:
    podman exec -it -u user -w /home/user ubuntu-box /bin/bash

# Stop Ubuntu container
stop:
    podman stop ubuntu-box

# Remove Ubuntu container
remove:
    podman rm ubuntu-box

# Restart Ubuntu container
restart: stop remove start
