# Documentation Index

This directory contains technical documentation for the Paschal Engineering infrastructure.

## Quick Reference

### 📚 [LESSONS-LEARNED.md](./LESSONS-LEARNED.md)
**Knowledge Base** - Searchable reference for common issues and solutions. Includes:
- Plex path mismatches and container volume configuration
- Container UID/GID permission issues
- DNS resolution problems
- Media management and TRaSH Guides compliance
- General troubleshooting principles

### 📋 [TODO.md](./TODO.md)
Current task list and work priorities

### 📊 [PROGRESS.md](./PROGRESS.md)
Project milestones and session summaries

### 🌐 [myenvironment.md](./myenvironment.md)
Complete infrastructure documentation:
- Network topology (UDM Pro, VLANs, firewall rules)
- htnas02 server configuration
- All services and containers
- Tailscale VPN setup

## Security Documentation

### 🔒 [UDM-PRO-FIREWALL-AUDIT.md](./UDM-PRO-FIREWALL-AUDIT.md)
Firewall configuration audit results

### 🔍 [NETWORK-ISOLATION-FINDINGS.md](./NETWORK-ISOLATION-FINDINGS.md)
Network segmentation analysis

## Credentials

### 🔑 [CREDENTIALS-README.md](./CREDENTIALS-README.md)
Secure credential management guide

## Session Notes

Historical session notes are stored in the [sessions/](./sessions/) directory.

---

## Common Use Cases

**When something breaks:** Check [LESSONS-LEARNED.md](./LESSONS-LEARNED.md) first - it contains root cause analysis and solutions for known issues.

**Planning work:** Review [TODO.md](./TODO.md) for current priorities and [PROGRESS.md](./PROGRESS.md) for context.

**Setting up new services:** Refer to [myenvironment.md](./myenvironment.md) for network/infrastructure patterns.

**Security questions:** Start with [UDM-PRO-FIREWALL-AUDIT.md](./UDM-PRO-FIREWALL-AUDIT.md) and [NETWORK-ISOLATION-FINDINGS.md](./NETWORK-ISOLATION-FINDINGS.md).
