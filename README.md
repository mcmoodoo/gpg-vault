# Double encrypt your GPG keys with age and back up to S3 bucket

## Flow

```mermaid
%%{init: {'theme':'dark', 'themeVariables': { 'primaryColor':'#1f2937', 'primaryTextColor':'#fff', 'primaryBorderColor':'#7C0000', 'lineColor':'#F8B229', 'secondaryColor':'#006100', 'tertiaryColor':'#1a1a2e', 'background':'#0f0f0f', 'mainBkg':'#1f2937', 'secondBkg':'#006100', 'tertiaryBkg':'#1a1a2e', 'textColor':'#fff', 'labelTextColor':'#fff', 'noteTextColor':'#fff', 'actorTextColor':'#fff', 'actorLineColor':'#fff' }}}%%
sequenceDiagram
    participant GPG as 🔐 ~/.gnupg
    participant Keys as 📁 gpg-vault/keys/
    participant S3 as ☁️ S3 Bucket

    rect rgb(34, 139, 34)
        Note over GPG,S3: 📤 Backup
        GPG->>+Keys: 🔑 export keys
        Keys->>Keys: 🔒 age encrypt
        Keys->>-S3: ⬆️ upload .age
    end
    
    rect rgb(65, 105, 225)
        Note over GPG,S3: 📥 Restore
        S3->>+Keys: ⬇️ download .age
        Keys->>Keys: 🔓 age decrypt
        Keys->>-GPG: 🔑 import keys
    end
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
