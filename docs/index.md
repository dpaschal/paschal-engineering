# Paschal Engineering Infrastructure

Welcome to the Paschal Engineering infrastructure documentation and knowledge base.

## Quick Navigation

### 🆘 Having Issues?
Check the **[Knowledge Base (Lessons Learned)](LESSONS-LEARNED.md)** for common problems and solutions.

### 📖 Documentation
- **[Environment Overview](myenvironment.md)** - Complete infrastructure topology and service catalog
- **[Progress Tracking](PROGRESS.md)** - Project milestones and updates
- **[TODO List](TODO.md)** - Current work items and priorities

### 🔒 Security
- **[Firewall Audit](UDM-PRO-FIREWALL-AUDIT.md)** - UDM Pro firewall configuration review
- **[Network Isolation](NETWORK-ISOLATION-FINDINGS.md)** - VLAN segmentation analysis

## Infrastructure Overview

### Primary Server: htnas02
Dell PowerEdge R630 running Ubuntu 24.04 LTS
- **IP Address:** 192.168.4.144
- **Storage:** ZFS pool (59TB capacity)
- **Container Runtime:** Podman
- **Services:** Plex, Sonarr, Radarr, SABnzbd, Grafana, Prometheus, and more

### Network
- **Router:** UDM Pro with multiple VLANs
- **VPN:** Tailscale for remote access
- **DNS:** Local resolution via /etc/hosts for *.htnas02 domains

## Common Tasks

### Accessing Services
All services are accessible via Traefik reverse proxy:
```
http://service-name.htnas02/
```

### Monitoring
- **Grafana:** http://grafana.htnas02/
- **Prometheus:** http://prometheus.htnas02/

### Media Management
- **Plex:** http://plex.htnas02/
- **Sonarr:** http://sonarr.htnas02/
- **Radarr:** http://radarr.htnas02/
- **Overseerr:** http://overseerr.htnas02/

---

*Last updated: Check git-revision-date at bottom of each page*
