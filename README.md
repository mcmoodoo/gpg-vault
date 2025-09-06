# GPG Backup

Encrypt your GPG keys with age and back up to S3 bucket

## For

Doubly encrypt your GPG keys and backup to S3 bucket

## Flow

```mermaid
graph LR
    A[~/.gnupg] -->|export| B[keys/private-keys.asc]
    B -->|age encrypt| C[keys/private-keys.asc.age]
    C -->|upload| D[S3 Bucket]
    D -->|download| E[keys/private-keys.asc.age]
    E -->|age decrypt| F[keys/private-keys.asc]
    F -->|import| G[~/.gnupg]
```

1. Export GPG keys from `~/.gnupg` → `keys/private-keys.asc`
2. Encrypt with age → `keys/private-keys.asc.age`
3. Upload to S3 bucket
4. Restore: Download → Decrypt → Import to GPG

## Dependencies

- `gpg` - GNU Privacy Guard
- `age` - File encryption
- `just` - Task runner
- `aws` CLI - S3 operations

## Usage

```bash
just              # List commands
just gpg-export   # Export keys
just encrypt      # Encrypt with age
just drop-in-bucket # Upload to S3
just decrypt      # Decrypt backup
just gpg-import   # Import to GPG
```
