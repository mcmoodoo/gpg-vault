#!/usr/bin/env just

# Variables
current_dir := `pwd`

# Default recipe - show available commands
default:
    @just --list

# Decrypt age-encrypted file
decrypt encrypted-file="./encrypted/private-keys.asc.age":
    @mkdir -p gpg-backups
    @echo "Decrypting {{encrypted-file}}..."
    @age -d -o gpg-backups/private-keys.asc {{encrypted-file}}
    @echo "Decrypted to gpg-backups/private-keys.asc"
    @echo "Run 'just gpg-import' to import keys to ~/.gnupg"

# Encrypt GPG backup with age
encrypt file="gpg-backups/private-keys.asc":
    @mkdir -p encrypted
    @echo "Encrypting {{file}} with age..."
    @age -p -o encrypted/$(basename {{file}}).age {{file}}
    @echo "Encrypted to encrypted/$(basename {{file}}).age"
    @echo "Consider removing the unencrypted file: rm {{file}}"

# GPG backup and restore recipes

# Export GPG private keys from ~/.gnupg to local backup file
gpg-export:
    @mkdir -p gpg-backups
    @echo "Exporting GPG private keys from ~/.gnupg..."
    @gpg --export-secret-keys --armor > gpg-backups/private-keys.asc
    @echo "Private keys exported to gpg-backups/private-keys.asc"
    @echo "These keys contain both private and public keys"
    @echo "Use 'just encrypt gpg-backups/private-keys.asc' to encrypt with age"

# Import GPG private keys from backup file to ~/.gnupg
gpg-import:
    @if [ ! -f "gpg-backups/private-keys.asc" ]; then \
        echo "Error: gpg-backups/private-keys.asc not found"; \
        echo "First decrypt with: just decrypt encrypted/private-keys.asc.age"; \
        exit 1; \
    fi
    @echo "Importing GPG keys to ~/.gnupg..."
    @gpg --import gpg-backups/private-keys.asc
    @echo "Keys imported successfully"
    @gpg --list-secret-keys
