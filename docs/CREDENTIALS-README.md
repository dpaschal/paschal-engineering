# Credentials & Secrets

**SECURITY NOTICE:** All credentials in the documentation have been redacted.

## Where to Find Actual Credentials

- **Local Environment Docs:** `~/AI/myenvironment.local.md` (on kube01 and laptop)
- **Local To-Do:** `~/AI/to-do.local.md` (on kube01 and laptop)
- **Password Manager:** [Your password manager here]

## Files with Real Credentials (DO NOT COMMIT)

These files contain actual passwords and API keys:
- `myenvironment.local.md` (gitignored)
- `to-do.local.md` (gitignored)
- Any file matching `*.local.md` (gitignored)

## Redacted in Git

The following are redacted in all committed documentation:
- `[REDACTED]` - passwords and user credentials
- `[REDACTED-VPN-PSK]` - VPN Pre-Shared Keys
- `[REDACTED-TWILIO-TOKEN]` - Twilio API tokens
- `[REDACTED-CLOUDFLARE-TOKEN]` - Cloudflare API tokens
- `[REDACTED-*]` - Any other API keys or tokens

**Keep the .local.md files synchronized with the redacted versions**, just with real credentials filled in.
