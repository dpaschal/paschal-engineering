# Lessons Learned

This document captures critical lessons learned during infrastructure work on kube01. Each entry includes the problem, root cause, solution, and key takeaways to prevent similar issues in the future.

---

## Plex & Container Configuration

### Plex Path Mismatch / Container Volume Mounts

**Date:** 2025-12-03
**Severity:** High
**Impact:** Complete playback failure in Plex

#### Problem
Plex showed "Playback Error: Please check that the file exists and the necessary drive is mounted" for all media files, despite files being present and accessible on the host system.

#### Root Cause
Container volume mount paths did not match the paths stored in Plex's database:
- Plex database expected: `/data/movies/` and `/data/tv/`
- Container provided: `/data/media/movies/` and `/data/media/tv/`
- Plex could not find files because the absolute paths in its database pointed to non-existent mount points inside the container

#### Solution
Updated `podman-compose.yml` to mount media directories at the paths Plex expected:

**Before:**
```yaml
volumes:
  - /data/media:/data/media
```

**After:**
```yaml
volumes:
  - /data/media/movies:/data/movies
  - /data/media/tv:/data/tv
```

#### Key Takeaways
1. **Container mount paths MUST match database expectations** - Plex stores absolute file paths
2. **Check application databases when files "don't exist"** - The error message was misleading
3. **Path mismatches happen before network traffic** - tcpdump showed nothing because Plex never attempted playback
4. **Always verify mount paths after migration** - OS migration (Ubuntu 22.04 → 24.04) changed container setup

#### Diagnostic Commands
```bash
# Query Plex database for expected paths
sqlite3 /data/appdata/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases/com.plexapp.plugins.library.db "SELECT * FROM section_locations;"

# Verify actual container mounts
podman exec plex ls -la /data/

# Check if files are accessible from inside container
podman exec plex ls -la /data/movies/ | head -20
```

---

### Container UID/GID Mismatches

**Date:** 2025-12-02
**Severity:** Medium
**Impact:** Permission denied errors, failed file operations

#### Problem
Radarr logs showed "Permission denied" errors when trying to move/rename downloaded files.

#### Root Cause
Containers were running with PUID=1000/PGID=1000, but media files on host were owned by UID 100999 (carried over from previous system migration).

#### Solution
Updated all media stack containers to use PUID=100999/PGID=100999:
- Plex
- Sonarr
- Radarr
- SABnzbd

#### Key Takeaways
1. **Container UID/GID must match host file ownership** - Required for read/write access
2. **Check file ownership after OS migration** - UIDs can change between systems
3. **All containers in a stack should use same UID/GID** - Ensures consistent permissions

#### Diagnostic Commands
```bash
# Check file ownership on host
ls -ln /data/media/movies/ | head -20

# Check running container UID
podman exec plex ps aux | grep plex

# Verify PUID/PGID environment variables
podman exec plex env | grep PUID
```

---

## Network & DNS

### DNS Resolution / Duplicate /etc/hosts Entries

**Date:** 2025-12-02
**Severity:** Medium
**Impact:** Intermittent service connectivity issues

#### Problem
Services on kube01 (dashy.kube01, plex.kube01, etc.) were intermittently unreachable from laptop, showing "ERR_ADDRESS_UNREACHABLE" in browser.

#### Root Cause
`/etc/hosts` on laptop contained duplicate entries for *.kube01 hostnames:
- Old entries pointing to 192.168.1.145 (previous VLAN)
- New entries pointing to 192.168.4.144 (current VLAN)
- DNS resolution was inconsistent depending on which entry was matched first

#### Solution
Removed all old entries pointing to 192.168.1.145:
```bash
sudo sed -i '/^192\.168\.1\.145.*kube01/d' /etc/hosts
```

#### Key Takeaways
1. **Clean up old /etc/hosts entries after IP changes** - Duplicate entries cause unpredictable behavior
2. **Use `getent hosts` to verify DNS resolution** - Shows which IP is actually being resolved
3. **Check /etc/hosts before debugging complex network issues** - Often the simplest explanation
4. **Document IP addressing changes** - Makes cleanup easier during future troubleshooting

#### Diagnostic Commands
```bash
# Check which IP is being resolved
getent hosts dashy.kube01

# Find all kube01 entries
grep kube01 /etc/hosts

# Verify connectivity to specific IP
curl -I http://192.168.4.144:8080
```

---

## Media Management

### TRaSH Guides Compliance & Bulk Renaming

**Date:** 2025-12-03
**Severity:** Low
**Impact:** Inconsistent file naming, reduced automation efficiency

#### Problem
Existing media library had mixed naming conventions, many files not following TRaSH Guides standard naming format.

#### Root Cause
Files were added to library before TRaSH naming schemes were implemented. New naming configuration only affected new downloads, not existing files.

#### Solution
1. Verified hardlink configuration was optimal (all paths under `/data` parent)
2. Triggered bulk rename via Sonarr API for all TV shows
3. Triggered bulk rename via Radarr API for all 2,237 movies

```bash
# Sonarr bulk rename
curl -X POST http://192.168.4.144:8989/api/v3/command \
  -H "X-Api-Key: $SONARR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name": "RenameSeries"}'

# Radarr bulk rename (requires movie IDs)
curl -X POST http://192.168.4.144:7878/api/v3/command \
  -H "X-Api-Key: $RADARR_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"RenameMovie\", \"movieIds\": [1,2,3,...]}"
```

#### Key Takeaways
1. **Bulk rename is safe with hardlinks** - Operations are instant if source and destination share parent directory
2. **Radarr RenameMovie requires explicit movie IDs** - Get them from `/api/v3/movie` endpoint
3. **Sonarr RenameSeries works on entire library** - No series IDs needed
4. **TRaSH naming schemes improve automation** - Consistent naming helps Custom Formats work correctly
5. **Preserve custom quality profiles during compliance** - Don't blindly overwrite all settings

#### Diagnostic Commands
```bash
# Check if hardlinks are possible (same filesystem)
df -h /data/media /data/usenet

# Get all movie IDs from Radarr
curl -s http://192.168.4.144:7878/api/v3/movie -H "X-Api-Key: $KEY" | jq '.[].id'

# Monitor rename progress
curl -s http://192.168.4.144:7878/api/v3/command/233557 -H "X-Api-Key: $KEY" | jq
```

---

## General Troubleshooting Principles

### Investigation Over Assumption

**Key Lesson:** When troubleshooting complex issues, actual investigation (using agents, database queries, log analysis) is more effective than educated guesses based on similar past problems.

**Example:** The Plex playback issue appeared to be a permissions problem (similar to recent UID/GID issues), but actual investigation revealed it was a path mismatch issue. Assumption-based troubleshooting wasted time and frustrated the user.

**Best Practice:**
1. Use agents to investigate comprehensively before proposing solutions
2. Query application databases/configs to understand expected vs actual state
3. Capture actual error conditions (logs, tcpdump, strace) rather than reproducing symptoms
4. Verify assumptions with concrete evidence before implementing fixes

---

## Future Reference

### Common Investigation Commands

```bash
# Container inspection
podman ps --all
podman logs <container> --tail 100
podman exec <container> env
podman inspect <container>

# File permissions
ls -ln <path>
stat <file>
getfacl <file>

# Network debugging
tcpdump -i any -n host <ip>
ss -tlnp
curl -v http://<service>

# Database queries (Plex)
sqlite3 /data/appdata/plex/.../com.plexapp.plugins.library.db "SELECT * FROM section_locations;"

# API debugging (*arr apps)
curl -s http://<service>/api/v3/system/status -H "X-Api-Key: $KEY" | jq
```
