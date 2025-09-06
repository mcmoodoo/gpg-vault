#!/usr/bin/env just

# Default recipe - show available commands
default:
    @just --list

# Export GPG keys from ~/.gnupg
gpg-export:
    @mkdir -p keys
    @gpg --export-secret-keys --armor > keys/private-keys.asc
    @echo "Exported to keys/private-keys.asc"

# Import GPG keys to ~/.gnupg
gpg-import:
    @[ -f "keys/private-keys.asc" ] || (echo "Error: keys/private-keys.asc not found" && exit 1)
    @gpg --import keys/private-keys.asc
    @gpg --list-secret-keys

# Encrypt file with age
encrypt file="keys/private-keys.asc":
    @age -p -o {{file}}.age {{file}}
    @echo "Encrypted to {{file}}.age"

# Decrypt file with age
decrypt file="keys/private-keys.asc.age":
    @age -d -o $(echo {{file}} | sed 's/\.age$//') {{file}}
    @echo "Decrypted to $(echo {{file}} | sed 's/\.age$//')"