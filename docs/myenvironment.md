# My Environment Documentation

**Last Updated:** 2025-12-03 03:00 UTC
**Author:** Automated documentation by Claude Code
**Session:** kube01 Ubuntu migration complete - All services operational on new OS

---

## Table of Contents
1. [Network Overview](#network-overview)
2. [htnas02 Server](#htnas02-server)
3. [Container Stack](#container-stack)
4. [Monitoring & Automation](#monitoring--automation)
5. [IoT Networks & Devices](#iot-networks--devices)
6. [Tailscale VPN](#tailscale-vpn)
7. [Firewall Rules](#firewall-rules)
8. [Credentials & Access](#credentials--access)

---

## Network Overview

### **Network Topology**
- **WAN:** 75.177.6.226/19 (via UDM Pro eth8)
- **UDM Pro:** 192.168.1.1 (root/[REDACTED])

### **VLANs / Subnets**
| Network | VLAN | Gateway | Purpose |
|---------|------|---------|---------|
| 192.168.1.0/24 | br0 | 192.168.1.1 | Main LAN |
| 10.0.0.0/24 | br10 | 10.0.0.1 | Internal/Server Network |
| 192.168.2.0/24 | br2 | 192.168.2.1 | Home Network |
| 192.168.3.0/24 | br3 | 192.168.3.1 | Laptop Network |
| 192.168.4.0/24 | br4 | 192.168.4.1 | IoT Network |

---

## Site-to-Site VPN (Home ↔ Kona)

### **VPN Configuration**
**Type:** IPsec Site-to-Site VPN
**Status:** Active and operational
**Established:** 2025-11-28
**Pre-Shared Key:** [REDACTED-VPN-PSK]
**VPN Method:** Route Based
**Key Exchange:** IKEv1, AES-128, SHA1, DH Group 14

### **Home Side (Paschal-Enterprises)**
- **Local IP:** 75.177.6.226 (WAN1)
- **Hostname:** circuit.paschal-engineering.com
- **Remote Endpoint:** kona.paschal-engineering.com
- **Remote Networks:**
  - 192.168.5.0/24 (Kona Office)
  - 192.168.6.0/24 (Kona IoT-Guest)
  - 192.168.10.0/24 (Kona Cameras)
  - 10.10.0.0/24 (Kona Server)
  - 192.168.0.0/24 (Kona Management)

### **Kona Side (Kona Ice Office)**
- **Local IP:** 104.187.211.123 (WAN)
- **Hostname:** kona.paschal-engineering.com
- **Remote Endpoint:** circuit.paschal-engineering.com
- **Remote Networks:**
  - 192.168.1.0/24 (Home Main LAN)
  - 10.0.0.0/24 (Home Server)
  - 192.168.4.0/24 (Home IoT)

### **Kona Network Details**
| Network | VLAN | Gateway | Purpose |
|---------|------|---------|---------|
| 192.168.0.0/24 | 1 | 192.168.0.1 | Management (Default) |
| 192.168.5.0/24 | 2 | 192.168.5.1 | Office Network |
| 192.168.10.0/24 | 3 | 192.168.10.1 | Camera Network |
| 192.168.6.0/24 | 4 | 192.168.6.1 | IoT-Guest Network |
| 10.10.0.0/24 | 5 | 10.10.0.1 | Server Network |

**UDM Pro:** 192.168.0.1 (pacxis.built@gmail.com / Pacxis1.618!)
**WiFi Networks:**
- KonaOffice (5GHz, Office VLAN, WPA2/WPA3)
- KonaGuest (2.4GHz, IoT-Guest VLAN, WPA2/WPA3)

**Ports:**
- Port 1: U6 LR AP (All VLANs trunk)
- Port 2: NVR with 6 cameras (Cameras VLAN only)

### **Cloudflare DDNS**
Both sites use Cloudflare DDNS to maintain VPN connectivity when ISP assigns new IPs.

**Home DDNS:**
- **Hostname:** circuit.paschal-engineering.com
- **Record ID:** a5d2aaecddcc29983191957b0447d188
- **Script:** `/usr/local/bin/cloudflare-ddns.sh` (runs every 5 min via cron on htnas02)
- **Log:** `/var/log/cloudflare-ddns.log`

**Kona DDNS:**
- **Hostname:** kona.paschal-engineering.com
- **Record ID:** 1835e6d1b1f298a634ef98d88a051448
- **Script:** `/usr/local/bin/kona-ddns.sh` (runs every 5 min via cron on htnas02)
- **Log:** `/var/log/kona-ddns.log`

### **VPN Performance**
- **Latency:** ~40ms average
- **Connectivity:** All networks reachable bidirectionally
- **Tested:** 2025-11-28 - Verified home → Kona connectivity

---

## Local Workstation

### **fedora (Primary Laptop)**
- **Hostname:** fedora
- **OS:** Fedora 43 (Forty Three)
- **Network:** 192.168.3.0/24 (br3 - Laptop Network)
- **Tailscale IP:** 100.91.219.31 (fedora.tail4262ae.ts.net)
- **User:** paschal
- **Home Directory:** `/home/paschal`

**Important File Locations:**
- **Screenshots:** `/home/paschal/Pictures/Screenshots/` (use `ls -lt | head` to find latest)
- **AI Working Directory:** `/home/paschal/AI/`
- **Environment Documentation:** `/home/paschal/AI/myenvironment.md`

### **Custom DNS Resolution**
**Method:** Local /etc/hosts file for htnas02 service access

**Configuration:** `/etc/hosts`
```
# Caddy reverse proxy services on htnas02
10.0.0.2 plex.htnas02
10.0.0.2 sonarr.htnas02
10.0.0.2 radarr.htnas02
10.0.0.2 sabnzbd.htnas02
10.0.0.2 prowlarr.htnas02
10.0.0.2 overseerr.htnas02
10.0.0.2 dashy.htnas02
10.0.0.2 n8n.htnas02
10.0.0.2 grafana.htnas02
```

**Access Method:**
- Services accessed via **https://\<service\>.htnas02** (e.g., https://grafana.htnas02)
- Caddy reverse proxy on htnas02 handles TLS termination
- Custom /etc/hosts provides local DNS resolution
- Self-signed certificates used for HTTPS

---

## htnas02 Server

### **Hardware Specifications**
- **Model:** Dell PowerEdge R630
- **CPUs:** 2x Intel Xeon E5-2697 v4 (18 cores/36 threads each, 145W TDP, Tmax 85°C)
- **RAM:** 750GB DDR4
- **GPU:** NVIDIA Tesla P4 (for Plex transcoding - **NOT YET CONFIGURED**)
- **Storage:**
  - OS: 115GB SSD (/dev/sda) - Ubuntu 24.04 LTS
  - Data: 10x 14TB drives (/dev/sdc-sdl) in ZFS RAIDZ2 - 59TB usable
- **Network:**
  - **Current:** 192.168.4.144 (IoT VLAN via eno4 - 1GbE)
  - **Intended:** 10.0.0.2 (VLAN 10 via eno1 - 10GbE) - **NOT YET WORKING**
  - Accessible via SSH from 192.168.1.0/24, 192.168.4.0/24, 100.64.0.0/10 (Tailscale)
- **iDRAC:** 192.168.1.51 (idrac-6CX7QD2, root/SixHundred#to1)
- **UPS:** APC at 192.168.1.215 (apc8A35F0) - **CURRENTLY DISCONNECTED (cable borrowed for kube01 eno4)**

### **Operating System**
- **OS:** Ubuntu 24.04 LTS (Fresh install 2025-12-02)
- **Hostname:** kube01 (will be renamed to kube01 in future)
- **Kernel:** Linux 6.x
- **Container Runtime:** Podman (using `sudo podman-compose` for rootful deployment)
- **User:** paschal (UID 1000, GID 1000, password: test123)

### **Storage Layout (ZFS)**
```
Filesystem                        Size  Used  Avail  Use%  Mounted on
data                               61T  572G   60T    1%   /data
data/appdata                       60T   22G   60T    1%   /data/appdata
data/downloads                     60T  256K   60T    1%   /data/downloads
data/media                        105T   46T   60T   44%   /data/media
data/downloads/complete            60T  256K   60T    1%   /data/downloads/complete
data/downloads/incomplete          60T  256K   60T    1%   /data/downloads/incomplete
data/downloads/usenet              60T  256K   60T    1%   /data/downloads/usenet
data/downloads/usenet/incomplete   60T  256K   60T    1%   /data/downloads/usenet/incomplete
data/downloads/usenet/complete     60T  256K   60T    1%   /data/downloads/usenet/complete
```

### **Key Paths**
- **Compose File:** `/data/appdata/compose/podman-compose.yml`
- **App Data:** `/data/appdata/`
- **Media:** `/data/media/`
- **Ramdisk:** `/data/ramdisk/` (for logs/PIDs)

---

## kube01 Server (Kubernetes Cluster)

### **Hardware Specifications**
- **Model:** Dell PowerEdge R630
- **CPUs:** 2x Intel Xeon E5-2620 v3 @ 2.40GHz (6 cores/12 threads each)
- **Memory:** 128GB DDR4
- **Storage:** Multiple drives (TBD - to be configured)
- **Network:** 4x 1GbE (eno1-4), eno4 active
- **Hostname:** kube01
- **IP Address:** 192.168.1.145/24 (Static)
- **OS:** NixOS 25.05 (Stable)
- **iDRAC:** 192.168.1.96 (idrac-JV1GHB2, root/[REDACTED])

### **Software Stack**
- **Kubernetes:** K3s v1.32.7+k3s1 (single-node, expandable)
- **Container Runtime:** containerd (included with K3s)
- **CNI:** Flannel (K3s default)
- **Ingress:** Traefik disabled (will deploy custom ingress)

### **Access**
- **SSH:** `ssh paschal@192.168.1.145` (password: [REDACTED])
- **kubectl:** Kubeconfig saved at `~/AI/kube01-kubeconfig.yaml`
- **K3s API:** https://192.168.1.145:6443

### **Kubernetes Info**
```bash
# Access from laptop
export KUBECONFIG=~/AI/kube01-kubeconfig.yaml
kubectl get nodes
kubectl get pods -A

# Access from kube01 directly
ssh paschal@192.168.1.145
sudo k3s kubectl get nodes
```

### **Network Configuration**
- Static IP: 192.168.1.145/24
- Gateway: 192.168.1.1
- DNS: 192.168.1.1, 8.8.8.8
- Managed by: systemd-networkd

### **Firewall (enabled)**
- Port 22: SSH
- Port 6443: K3s API
- Port 10250: Kubelet
- UDP 8472: Flannel VXLAN

### **Status**
✅ **Operational** - K3s cluster running, network configured, ready for workload deployment

---

## Container Stack

### **Container Runtime**
- **Engine:** Podman 4.9.3 (rootless, running as `paschal` user)
- **Network:** All containers on `compose_default` bridge (10.89.3.0/24)
- **Docker Compatibility:** `/usr/bin/docker` is a wrapper script that redirects to podman
- **Auto-Update:** Daily at 4:00 AM via cron job

### **Documentation & Knowledge Base**

**MkDocs Sites (2 instances):**

1. **Paschal Engineering Infrastructure Docs** (Currently Running)
   - **Location:** `/data/appdata/paschal-engineering/`
   - **Containers:** docs-dev (port 8083), docs-prod (port 8084)
   - **Access:**
     - Dev: https://docs-dev.kube01
     - Prod: https://docs.kube01
   - **Content:** Infrastructure documentation, security audits, credentials, progress tracking, TODO
   - **In Dashy:** ✅ Yes
   - **Status:** ✅ Running

2. **Lab Blog / Wiki** (Not Currently Running)
   - **Location:** `/data/appdata/lab-blog/`
   - **Container:** Not deployed
   - **Content:** Blog posts, project notes, server inventory, K8s migration tracking
   - **Status:** ❌ Not accessible (files exist but no running container)
   - **Note:** Wiki was converted from MediaWiki to MkDocs format

**Legacy Wiki (Deprecated):**
- **Location:** `/data/appdata/labwiki/` (MediaWiki + MariaDB)
- **Status:** ❌ Not running, superseded by lab-blog MkDocs

### **Running Containers (17 total)**

#### **LFG Demo Stack (Isolated Network)**
| Container | Port | Image | Purpose |
|-----------|------|-------|---------|
| lfg-grafana | 3001 | docker.io/grafana/grafana:latest | Public demo dashboards (read-only, anonymous) |
| lfg-prometheus | 9092 | docker.io/prom/prometheus:latest | Demo metrics storage (90-day retention) |

**⚠️ CRITICAL: Multiple Grafana Instances**
- **Main Grafana (grafana):** Port 3000 - Home lab monitoring (Plex, *arr apps, system metrics)
- **LFG Demo Grafana (lfg-grafana):** Port 3001 - Isolated public demo (weather, Lincoln insights)
- **ALWAYS specify which Grafana** when making changes: use container name or port number
- **Configuration paths:**
  - Main Grafana: `/data/appdata/grafana/` (port 3000)
  - LFG Demo Grafana: `/data/appdata/lfg-demo/grafana-provisioning/` (port 3001)

**Network:** `lfg-demo` (10.90.0.0/24) - Isolated from home lab
**Security:** Container hardening, read-only access, anonymous viewer mode
**Documentation:** `/data/appdata/lfg-demo/LFG-DEMO-DOCUMENTATION.md`
**Access:** http://10.0.0.2:3001 (local), Future: https://grafana.paschal-engineering.com
**Datasource:** http://10.0.0.2:9092 (lfg-prometheus on port 9092, NOT 9090)

#### **Media Automation Stack**
| Container | Port | Image | Purpose |
|-----------|------|-------|---------|
| plex | 32499 | lscr.io/linuxserver/plex:latest | Media server with GPU transcoding |
| sonarr | 8989 | lscr.io/linuxserver/sonarr:latest | TV show automation |
| radarr | 7878 | lscr.io/linuxserver/radarr:latest | Movie automation |
| sabnzbd | 8080 | lscr.io/linuxserver/sabnzbd:latest | Usenet downloader |
| prowlarr | 9696 | lscr.io/linuxserver/prowlarr:latest | Indexer manager |
| overseerr | 5055 | lscr.io/linuxserver/overseerr:latest | Media request management |

#### **Infrastructure Services**
| Container | Port | Image | Purpose |
|-----------|------|-------|---------|
| caddy | 80, 443 | docker.io/library/caddy:latest | Reverse proxy with TLS |
| dashy | 4000 | ghcr.io/lissy93/dashy:latest | Dashboard UI |

#### **Monitoring Stack**
| Container | Port | Image | Purpose |
|-----------|------|-------|---------|
| grafana | 3000 | docker.io/grafana/grafana:latest | Visualization dashboards |
| prometheus | 9090 | docker.io/prom/prometheus:latest | Time series database (5 year retention) |
| pushgateway | 9091 | docker.io/prom/pushgateway:latest | Metrics receiver for n8n workflows |
| node-exporter | 9100 (host) | quay.io/prometheus/node-exporter:latest | System metrics |
| cadvisor | 8081 | gcr.io/cadvisor/cadvisor:latest | Container metrics |
| nut-exporter | 9199 (host) | localhost/nut-exporter:latest | UPS metrics (custom build) |

#### **Automation**
| Container | Port | Image | Purpose |
|-----------|------|-------|---------|
| n8n | 5678 | localhost/compose_n8n:latest | Workflow automation (custom build with NUT support) |

**n8n Automation:**

**Access:** https://n8n.htnas02 (API Key configured)

**Active Workflows (20 total):**

*LFG Demo Workflows (7):*
1. **LFG Weather - Lincoln, NE** (`1f710a1b-785c-4d13-858f-34e973fed72a`) - Every 5 min - Multi-location weather for LFG demo
2. **LFG Weather - Greensboro, NC** (`668f9021-0574-42d9-b399-072ed8df1135`) - Every 5 min - Greensboro weather data
3. **LFG Weather - Ashburn, VA** (`dd93930d-4729-4ad3-a8cc-f3e0c9e3d691`) - Every 5 min - Ashburn weather data
4. **LFG Weather - Chicago, IL** (`c256fcb1-224b-4917-b052-03d917101ca4`) - Every 5 min - Chicago weather data
5. **LFG Lincoln - City Statistics** (`db9344e3-5c9a-4534-97e2-bcaab5e6f357`) - Daily 6 AM - Lincoln population, income, unemployment
6. **LFG Lincoln - Huskers Sports** (`f28a34c5-1384-49bb-88ae-40a6608b4c53`) - Every 4 hours - Nebraska Huskers football stats
7. **LFG Lincoln - Air Quality** (`9f68cc53-b063-41b1-a517-4a7d64767a0c`) - Every 30 min - Lincoln air quality (PM2.5, PM10, O3, NO2)

*Home Lab Workflows (10):*
8. **SABnzbd Cleanup** (`QBRKCpSlGNGDA4Pm`) - Every 5 min - Removes encrypted/paused downloads
9. **Temperature Monitoring** (`4LGUsZsqrBaCEieg`) - Every 5 min - Monitors CPU/GPU/disk temps via fan-exporter
10. **Storage Monitoring** (`uyPWvv05AoHzBXKC`) - Hourly - Checks /data ZFS pool usage
11. **Smart Container Updates** (`q9iV0AuscbC4dzK5`) - Daily 4 AM - Automated container updates via podman
12. **ZFS Scrub Coordinator** (`DICzRMd7tIW1bm95`) - Monthly (1st @ 3 AM) - Initiates ZFS data integrity scrub
13. **Container Health Monitor** (`Iqf9HEJXxMsEhWlW`) - Every 5 min - Monitors container status via podman
14. **Indexer Health Monitor** (`b5sRdS5PoAKphFnv`) - Hourly - Monitors Prowlarr indexer availability
15. **Download Queue Optimizer** (`wyPeU9drRG1KhglV`) - Every 30 min - Tracks SABnzbd/Sonarr/Radarr queues
16. **Google Drive Sync Monitor** (`8V1j7a0oM9bMMcv1`) - Daily 2:10 AM - Monitors gdrive-sync service status
17. **Weather Monitoring** (`sAu1EWZPVzFWMOh5`) - Every 5 min - Fetches NWS weather data for Pleasant Garden, NC

*Webhook-Based Workflows (3):*
18. **Smart Download Gating (Sonarr)** (`lX0kIDH7miFFjyvV`) - Webhook: `/webhook/sonarr-download` - Tracks TV show grabs
19. **Smart Download Gating (Radarr)** (`mblcywR1E1v29n6h`) - Webhook: `/webhook/radarr-download` - Tracks movie grabs
20. **Failed Download Intelligence** (`miLX6Bt4IdGIGj0p`) - Webhook: `/webhook/download-failed` - Tracks failed downloads
21. **Import Coordination** (`sd6yBZtdR9txAj1X`) - Webhook: `/webhook/media-imported` - Tracks successful imports

**Metrics Collection:**
- All workflows push metrics to Pushgateway (pushgateway:9091)
- Prometheus scrapes metrics every 15 seconds
- Metrics available in Grafana for visualization
- Metric prefixes: `n8n_*` (e.g., `n8n_temperature_alert`, `n8n_storage_usage`, `n8n_container_running`)

**Documentation:**
- Workflow blueprints: `/data/appdata/n8n/WORKFLOW-BLUEPRINTS.md`
- Implementation guide: `/data/appdata/n8n/IMPLEMENTATION-GUIDE.md`
- Deployment summary: `/data/appdata/n8n/DEPLOYMENT-SUMMARY.md`
- API credentials: `/data/appdata/n8n/api-credentials.txt` (mode 600)
- TRaSH Guides compliance: Verified compliant with TRaSH best practices

**Claude Code Workflow Creation:**
- **IMPORTANT:** Claude Code can create and import n8n workflows directly
- When requesting dashboards, automation, or data collection tasks, Claude Code should:
  1. First consider if n8n can be used for the task
  2. Create the n8n workflow JSON
  3. Import workflow directly into SQLite database (see below)
  4. Restart n8n: `podman restart n8n`
- Workflows can push metrics to Pushgateway for Prometheus/Grafana visualization
- This approach is preferred over custom Python scripts or standalone containers
- Example: Weather monitoring uses n8n instead of a dedicated weather-exporter container

**n8n Database Direct Import Method:**
⚠️ **CRITICAL:** When modifying n8n workflows via database:
1. **ALWAYS stop n8n container first:** `ssh paschal@10.0.0.2 "podman stop n8n"`
2. **Use sudo for database writes:** The database file `/data/appdata/n8n/database.sqlite` is owned by UID 100999 (container user)
3. **Execute Python with sudo:** `ssh paschal@10.0.0.2 "sudo python3 << 'ENDPY' ... ENDPY"`
4. **Start n8n after changes:** `ssh paschal@10.0.0.2 "podman start n8n"`

**Example workflow import:**
```bash
ssh paschal@10.0.0.2 "podman stop n8n && sudo python3 << 'ENDPY'
import sqlite3
import json
import uuid

# Load workflow JSON
with open('/tmp/workflow.json', 'r') as f:
    workflow_data = json.load(f)

# Connect to database
conn = sqlite3.connect('/data/appdata/n8n/database.sqlite')
cursor = conn.cursor()

# Insert workflow
workflow_id = str(uuid.uuid4())
cursor.execute('''
    INSERT INTO workflow_entity (id, name, active, nodes, connections, settings)
    VALUES (?, ?, ?, ?, ?, ?)
''', (
    workflow_id,
    workflow_data['name'],
    workflow_data.get('active', False),
    json.dumps(workflow_data['nodes']),
    json.dumps(workflow_data['connections']),
    json.dumps(workflow_data.get('settings', {}))
))

conn.commit()
conn.close()
print(f'Imported workflow: {workflow_id}')
ENDPY
podman start n8n"
```

**Why this is necessary:**
- n8n CLI import fails with directory-only input restrictions
- SQLite database is locked while n8n is running (causes "attempt to write a readonly database" error)
- Container user (UID 100999) owns the database file, requiring sudo for writes
- Direct database access is the most reliable method for workflow import

**Container Status:**
- **cadvisor:** Status is healthy. Container logs show repeated non-critical errors about missing /etc/machine-id file (benign - doesn't affect metrics collection)

### **Caddy Reverse Proxy**
**Note:** Caddy replaced Traefik as the reverse proxy due to compatibility issues with Traefik.

Caddy provides TLS termination using local certificates (`/etc/caddy/cert.pem`, `/etc/caddy/key.pem`) for:
- plex.htnas02
- sonarr.htnas02
- radarr.htnas02
- sabnzbd.htnas02
- prowlarr.htnas02
- overseerr.htnas02
- dashy.htnas02
- n8n.htnas02
- grafana.htnas02

**Caddyfile Location:** `/data/appdata/caddy/Caddyfile`

### **Prometheus Configuration**
**Config Location:** `/data/appdata/prometheus/prometheus.yml`

**Scrape Targets:**
- prometheus (localhost:9090) - Self monitoring
- nut-ups (10.0.0.2:9199) - UPS metrics from APC
- node-exporter (10.0.0.2:9100) - System metrics
- **fan-exporter (10.0.0.2:9201)** - CPU/GPU/disk temps and fan speeds ⚠️ **PORT 9201 NOT 9101**
- pushgateway (pushgateway:9091) - n8n workflow metrics

**Retention:** 1825 days (5 years)

### **Grafana Configuration**
- **URL:** http://10.0.0.2:3000 or https://grafana.htnas02
- **Version:** 12.3.0 (Open Source Edition)
- **Credentials:** admin/[REDACTED]
- **Container:** grafana (port 3000)

#### **Data Sources**
| Name | Type | URL | Status |
|------|------|-----|--------|
| prometheus | Prometheus | http://prometheus:9090 | Default |

#### **Dashboards**
1. **UPS Monitoring** (`/d/0e86d54f-8ad7-4b66-95e6-2a83eaaa5b55/ups-monitoring`)
   - Monitors APC UPS (192.168.1.215) via nut-exporter
   - 12 panels tracking:
     - Current stats: Battery Charge, Battery Runtime, Input Voltage, UPS Load, Real Power
     - Cost analysis: Cost per Hour, Monthly Cost, Estimated Daily Cost
     - Time series: Power Draw, Battery Charge, UPS Load, Voltage trends
   - Data source: Prometheus

2. **Dell R630 Fan Control - htnas02** (`/d/fan-control-htnas02-v2/dell-r630-fan-control-htnas02`)
   - Controls and monitors Dell R630 server fans
   - Data source: Prometheus

3. **Server Resources - htnas02 (LCD)** (`/d/85c3e63a-f1ba-4b0d-8849-5bdd58a710da/server-resources-htnas02-lcd`)
   - Modern LCD-style dashboard for htnas02 server metrics via node-exporter
   - Top row: Large stat panels with gradient backgrounds
     - CPU Usage % (green/yellow/red thresholds)
     - Memory Usage % (green/yellow/red thresholds)
     - Disk Usage /data (green/yellow/red thresholds)
     - Network Traffic (RX/TX rates)
   - Bottom section: Time series graphs
     - CPU Usage Over Time
     - Memory Usage Over Time (stacked: Used/Available)
     - Disk I/O (Read/Write by device)
     - Network Traffic Over Time (Receive/Transmit)
   - Refresh: 30 seconds
   - Data source: Prometheus

4. **Weather Dashboard - Pleasant Garden, NC** (`/d/b37806f6-efd7-4b8a-bd29-4318fa7b8915/weather-dashboard-pleasant-garden-nc`)
   - Real-time local weather from National Weather Service API
   - Location: Pleasant Garden, NC 27313 (Grid Square: FM05)
   - Station: KGSO (Greensboro Piedmont Triad International Airport)
   - 10 panels tracking:
     - Current conditions: Temperature, Humidity, Wind Speed, Barometric Pressure
     - 24-hour trends: Temperature/Dewpoint, Humidity
     - Additional metrics: Heat Index, Wind Chill, Visibility, Wind Direction
   - Data collected via n8n workflow every 5 minutes
   - Pushed to Pushgateway, scraped by Prometheus
   - Refresh: 5 minutes
   - Data source: Prometheus
   - Prepared for future LoRa sensor and WWV signal integration

---

## Monitoring & Automation

### **Network UPS Tools (NUT)**
**Installation:** Native systemd services (NOT containerized)
**Services:**
- `nut-server.service` - UPS information server (upsd)
- `nut-monitor.service` - UPS monitoring and shutdown controller (upsmon)

**Status:** Active and enabled (auto-start on boot)

**UPS Configuration:**
- **Device Name:** apc-ups
- **Model:** APC Smart-UPS 1500
- **Serial:** AS1448123891
- **Management Card:** APC Web/SNMP Management Card (192.168.1.215)
- **Driver:** snmp-ups (SNMP v2c protocol)
- **Poll Frequency:** 15 seconds
- **Connection:** Network-based via SNMP to 192.168.1.215

**Metrics Exposed:**
- Battery charge, voltage, runtime
- Input/output voltage and frequency
- UPS load and power consumption
- Metrics exposed via nut-exporter container on port 9199
- Scraped by Prometheus every 15 seconds
- Visualized in Grafana dashboard "NUT Monitoring - Final"

**Key Commands:**
```bash
# List available UPS devices
upsc -l

# Get all UPS statistics
upsc apc-ups

# Check NUT service status
systemctl status nut-server nut-monitor
```

### **Ollama AI Service**
**Installation:** Native systemd service (NOT containerized)
**Service:** `ollama.service`
**Status:** Active and enabled (auto-start on boot)
**Binary:** `/usr/local/bin/ollama`

**Configuration:**
- **Listen Address:** 0.0.0.0:11434 (accessible from local networks)
- **API Endpoint:** http://10.0.0.2:11434
- **Firewall Access:** 192.168.1.0/24, 192.168.3.0/24 (Laptop network)

**Installed Models:**
| Model | Size | Purpose |
|-------|------|---------|
| qwen2.5-coder:32b | 18.5GB | Large coding model (32B parameters) |
| qwen2.5-coder:7b | 4.4GB | Fast coding model (7B parameters) |
| llama3.2:3b | 1.9GB | Small general-purpose model (3B parameters) |

**Usage:**
```bash
# List installed models
curl http://10.0.0.2:11434/api/tags

# Generate completion
curl http://10.0.0.2:11434/api/generate -d '{"model":"llama3.2:3b","prompt":"Hello"}'

# Check service status
ssh 10.0.0.2 "systemctl status ollama"
```

### **Container Auto-Update**
**Script:** `/usr/local/bin/update-containers.sh`
**Schedule:** Daily at 4:00 AM (cron: `0 4 * * *`)
**Log:** `/var/log/container-updates.log`
**User:** paschal

**Actions:**
1. Pulls latest images via `podman-compose pull`
2. Detects image changes
3. Recreates containers with `--force-recreate` if updates found
4. Verifies containers are running
5. Cleans up old images (older than 24h)

### **Automated Maintenance Tasks (Timers)**

#### **ZFS Pool Scrub**
- **Timer:** `zpool-scrub@data.timer`
- **Schedule:** Monthly
- **Purpose:** Verify data integrity on ZFS pool 'data'
- **Action:** Runs `zpool scrub data` to check all blocks
- **Status:** Active

#### **SABnzbd Encrypted Download Cleanup**
- **Timer:** `sabnzbd-cleanup-encrypted.timer`
- **Schedule:** Custom (check timer for exact schedule)
- **Purpose:** Automatically removes failed/encrypted downloads from SABnzbd
- **Status:** Active

#### **System Maintenance Timers**
Additional active timers:
- **fstrim.timer** - Weekly SSD/filesystem trim
- **logrotate.timer** - Daily log rotation
- **apt-daily.timer** - Daily package list updates
- **sysstat-collect.timer** - System statistics collection every 10 minutes

### **Fan Control System**
**Service:** `fanctl.service` (systemd)
**Script:** `/usr/local/bin/fanctl.py`
**Version:** 2.1-disk-aware (Python 3)
**Status:** Active (running continuously)
**Management:** Monitored by n8n "Temperature Monitoring" workflow (every 5 min)

**Monitoring:**
- CPU temps (via IPMI)
- GPU temp (via nvidia-smi)
- Disk temps (via smartctl on sda-sdj)
- Check interval: 15 seconds (fanctl.py local control loop)
- n8n monitoring: Every 5 minutes via fan-exporter metrics

**Temperature Thresholds:**
- Disk target: ≤38°C (target), 42°C (max warning)
- Component temps: 50°C (idle) → 78°C (emergency → BIOS control)

**Fan Speed Levels:**
- 10% (~4000-5500 RPM) - Idle/quiet (disk <38°C, components <50°C)
- 14% (~4800-6200 RPM) - Moderate (disk 38-41°C)
- 18% (~5200-6800 RPM) - Active (disk target, not currently used)
- 24% (~6000-7800 RPM) - Heavy load (disk ≥42°C or components 62-70°C)
- 30% (~7000-9000 RPM) - High (components 70-75°C)
- Auto - BIOS control (emergency >78°C)

**Known Issues:**
- ⚠️ Fan cycling observed: Disk temp oscillates 41°C↔42°C causing fans to cycle 14%↔24%
  - Root cause: 42°C is exactly DISK_TEMP_MAX threshold
  - Solution needed: Add hysteresis or adjust thresholds

**Special Features:**
- Disables Dell's PCIe card fan override for Tesla P4 GPU
- Prioritizes disk cooling when temps exceed thresholds
- Logs to ramdisk: `/data/ramdisk/fanctl.log`, `/data/ramdisk/fanctl.pid`
- Metrics exported via fan-exporter (port 9201) for Prometheus/Grafana

### **Additional System Services**

#### **NVIDIA Persistence Daemon**
- **Service:** `nvidia-persistenced.service`
- **Purpose:** Keeps NVIDIA GPU initialized and ready for compute workloads
- **Status:** Active and running
- **Benefit:** Reduces latency for Plex transcoding and Ollama GPU acceleration

#### **ZFS Event Daemon (zed)**
- **Service:** `zfs-zed.service`
- **Purpose:** Monitors ZFS events and triggers actions (email alerts, scrubs, etc.)
- **Status:** Active and running
- **Pool:** data (10x 14TB drives)
- **Logs:** `/var/log/zfs/`

#### **SMART Monitoring**
- **Service:** `smartmontools.service`
- **Purpose:** Monitors disk health via S.M.A.R.T. data
- **Status:** Active and running
- **Monitored Drives:** sda through sdj (10 drives)
- **Configuration:** `/etc/smartd.conf`
- **Logs:** `/var/log/syslog` (disk health warnings)

---

## Asterisk VoIP Phone System

### **Overview**
**Phone Number:** +1 (743) 867-9908
**Provider:** Twilio (SIP)
**Container:** asterisk (docker.io/andrius/asterisk:latest)
**Status:** Active and running

### **Container Configuration**
- **Ports:**
  - 5060/udp, 5060/tcp - SIP signaling
  - 10000-10099/udp - RTP media
- **Volumes:**
  - `/data/appdata/asterisk/config:/etc/asterisk` - Configuration files
  - `/data/appdata/asterisk/recordings:/var/spool/asterisk` - Voicemail recordings
  - `/data/appdata/asterisk/state:/data/appdata/asterisk/state` - Call forwarding state
  - `/data/appdata/asterisk/scripts:/scripts` - Setup scripts

### **Twilio Integration**
**Method:** TwiML Webhook → SIP Forward

**TwiML Webhook:**
- **URL:** http://75.177.6.226:5679/voice.xml
- **Port:** 5679/tcp (nginx on paschal-websites container)
- **Content:** TwiML that forwards calls to Asterisk via SIP
- **Location:** `/data/appdata/websites/twiml/voice.xml`

**Twilio Credentials:**
- **Account SID:** AC2de6b702008f774b20d27899c775999
- **Auth Token:** [REDACTED-TWILIO-TOKEN]
- **Phone Number:** +17438679908

### **PJSIP Configuration**
**File:** `/data/appdata/asterisk/config/pjsip.conf`

**Endpoint:** twilio
- Context: from-twilio
- Codecs: ulaw, alaw
- Auth: AC2de6b702008f774b20d27899c775999:[REDACTED-TWILIO-TOKEN]
- External IPs: 75.177.6.226 (WAN)

### **Dialplan**
**File:** `/data/appdata/asterisk/config/extensions.conf`

**Context:** from-twilio
- Checks forwarding state: `/data/appdata/asterisk/state/forwarding.txt`
- If "enabled": Rings softphone for 30 seconds, then voicemail
- If "disabled": Goes directly to voicemail
- Voicemail: Mailbox 100

### **Voicemail**
**File:** `/data/appdata/asterisk/config/voicemail.conf`

**Mailbox 100:**
- **PIN:** 1234
- **Name:** Paschal Engineering
- **Email:** contact@paschal-engineering.com
- **Format:** WAV
- **Attach:** Yes (sends email with recording)
- **Max Messages:** 100
- **Max Length:** 180 seconds

**Recordings:** `/data/appdata/asterisk/recordings/voicemail/default/100/INBOX/`

### **Call Forwarding Control**
**Enable forwarding to softphone:**
```bash
echo "enabled" > /data/appdata/asterisk/state/forwarding.txt
```

**Disable forwarding (voicemail only):**
```bash
echo "disabled" > /data/appdata/asterisk/state/forwarding.txt
```

**Current state:** disabled (all calls go to voicemail)

### **Management Commands**
```bash
# Check Asterisk status
podman exec asterisk asterisk -rx 'pjsip show endpoints'

# View live call activity
podman logs asterisk -f

# Check voicemail messages
ls -la /data/appdata/asterisk/recordings/voicemail/default/100/INBOX/

# Restart Asterisk
podman restart asterisk

# Test TwiML webhook
curl http://localhost:5679/voice.xml
```

### **Documentation**
- **Setup Guide:** `/data/appdata/asterisk/scripts/twilio-setup-guide.md`
- **Setup Status:** `/data/appdata/asterisk/scripts/SETUP-STATUS.md`

---

## IoT Networks & Devices

### **192.168.1.0/24 (br0) - Main LAN**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.1.51 | 84:7b:eb:d4:c0:d2 | idrac-6CX7QD2 | Dell R630 iDRAC |
| 192.168.1.215 | 00:c0:b7:8a:35:f0 | apc8A35F0 | APC UPS (NMC) |
| 192.168.1.21 | e8:ea:6a:49:f9:72 | LFG-VY264HR-Mac | Mac computer |
| 192.168.1.178 | 08:2e:5f:bd:96:fb | NPIBD96FB | Network printer |

### **192.168.2.0/24 (br2) - Home Network**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.2.149 | 28:ea:0b:b5:2c:5a | XBOX | Gaming console |
| 192.168.2.81 | 2a:45:6c:9b:31:0d | iPad | Tablet |
| 192.168.2.154 | 68:db:f5:3c:48:f2 | - | Roku device |

### **192.168.4.0/24 (br4) - IoT Network (PRIMARY)**

#### **Smart Home Devices (TP-Link Kasa)**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.4.84 | 5c:e9:31:9c:46:e1 | HS200 | Smart Switch |
| 192.168.4.113 | 5c:e9:31:4f:69:d8 | HS210 | 3-Way Smart Switch |
| 192.168.4.171 | e4:fa:c4:8d:1e:37 | HS103 | Smart Plug |
| 192.168.4.99 | a8:42:a1:55:3b:b3 | KL125 | Smart LED Bulb |
| 192.168.4.33 | 5c:e9:31:27:d4:cb | - | TP-Link device |
| 192.168.4.90 | e4:fa:c4:8d:1e:df | - | TP-Link device |
| 192.168.4.153 | 5c:e9:31:ea:9b:42 | - | TP-Link device |
| 192.168.4.180 | a8:42:a1:55:51:25 | - | TP-Link device |

#### **Security Cameras (Eufy)**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.4.193 | 04:17:b6:ce:ba:f0 | eufyFloodlightCam | Floodlight Camera |
| 192.168.4.196 | 04:17:b6:dc:b3:d0 | S380HB | Camera |
| 192.168.4.233 | 04:17:b6:bb:19:7e | - | Camera |
| 192.168.4.44 | 04:17:b6:cf:bc:b6 | - | Camera |
| 192.168.4.49 | 04:17:b6:ce:88:da | - | Camera |

#### **Entertainment Devices**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.4.143 | 20:ef:bd:a6:e3:8c | RokuPremiere | Streaming device |
| 192.168.4.234 | bc:d7:d4:ff:66:05 | RokuStreambarPro | Sound bar + streaming |
| 192.168.4.250 | 74:d6:37:33:6e:7c | amazon-c6309f898 | Amazon Echo/Alexa |

#### **Smart Home Hub**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.4.59 | 44:61:32:3a:2a:04 | Hallway | Nest Hub/Thermostat |

#### **Mobile Devices (IoT VLAN)**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 192.168.4.85 | 3e:1e:d5:43:15:cb | iPhone | iPhone |
| 192.168.4.241 | 96:cc:54:b5:39:7a | Pixel-8-Pro | Android phone |

### **10.0.0.0/24 (br10) - Internal/Server Network**
| IP | MAC | Hostname | Device Type |
|----|-----|----------|-------------|
| 10.0.0.2 | 18:66:da:68:27:a0 | htnas02 | Main server |

---

## Tailscale VPN

### **Configuration**
- **Tailnet:** dpaschal@gmail.com (tail4262ae.ts.net)
- **MagicDNS:** Enabled
- **Version:** 1.90.8 on htnas02
- **DERP Relay:** iad (Ashburn) - 36.2ms latency
- **Subnet Routing:** NOT configured
- **Exit Node:** NOT configured
- **SSH Server:** Disabled on htnas02

### **Connected Devices**

#### **Online**
| Device | Tailscale IP | IPv6 | OS | DNS Name |
|--------|--------------|------|----|----|
| htnas02 | 100.114.72.82 | fd7a:115c:a1e0::3b33:4852 | Linux | htnas02.tail4262ae.ts.net |
| fedora | 100.91.219.31 | - | Linux | fedora.tail4262ae.ts.net |
| msvr01 | 100.109.173.126 | fd7a:115c:a1e0::2c33:ad7e | Linux | msvr01.tail4262ae.ts.net |

#### **Offline**
| Device | Tailscale IP | Last Seen | OS |
|--------|--------------|-----------|-----|
| arch2 | 100.105.88.93 | 17 days ago | Linux |
| google-pixel-8-pro | 100.84.222.74 | 2 days ago | Android |
| htnas01 | 100.81.153.76 | 3 days ago | Linux |

### **Access**
- Key expiry: April 22, 2026
- htnas02 has admin/owner privileges
- File sharing enabled via PeerAPI
- **Use Case:** Host-to-host VPN for secure remote access to services on htnas02

### **Notes**
- UDM Pro does NOT have Tailscale installed
- No subnet routes advertised (can only access Tailscale hosts directly, not local networks)
- Direct connections via UDP when possible, otherwise uses DERP relay

---

## Firewall Rules

### **htnas02 (UFW)**
**Status:** Active
**Default Policy:** Deny incoming, Allow outgoing

#### **SSH Access**
- 192.168.1.0/24 (Main LAN)
- 10.0.0.0/24 (Internal network)
- 100.64.0.0/10 (Tailscale)
- 192.168.2.0/24 (Home network)
- 192.168.3.0/24 (Laptop network)

#### **Public Services**
- 32499/tcp - Plex Media Server (open to all)
- 80/tcp, 443/tcp - HTTP/HTTPS (open to all)
- 239.0.0.250/udp, 239.255.255.250/udp - Plex multicast discovery

#### **Restricted Services (Local networks + Tailscale)**
- 8989 - Sonarr
- 7878 - Radarr
- 8080 - SABnzbd
- 9696 - Prowlarr
- 5055 - Overseerr
- 3001 - LFG Grafana Demo (192.168.1.0/24, 192.168.3.0/24)
- 9092 - LFG Prometheus (192.168.1.0/24, 192.168.3.0/24) - optional for debugging

#### **Additional**
- 11434 - Ollama API (192.168.1.0/24, 192.168.3.0/24)
- 8180, 8181, 8143 - Legacy Traefik ports (uninstalled, rules can be removed)
- 53/udp - DNS forwarding for Podman containers on podman1

#### **Asterisk VoIP System**
- 5060/udp, 5060/tcp - SIP signaling (open to all for Twilio)
- 10000-10099/udp - RTP media (open to all for Twilio)
- 5679/tcp - TwiML webhook endpoint (open to all for Twilio)

#### **Tailscale Integration**
- ts-input, ts-forward chains active
- Allows traffic from Tailscale interface (tailscale0)
- Tailscale address: 100.114.72.82

### **UDM Pro (UBIOS Firewall)**
**Status:** Active (iptables-based)
**Architecture:** Zone-based firewall with UBIOS chains
**Web Interface:** https://192.168.1.1
**Access:** root/[REDACTED]
**Firmware:** Network 9.5.21

#### **⚠️ IMPORTANT: Firewall Configuration Location**
**To configure firewall rules in UDM Pro web interface:**
1. Log in to https://192.168.1.1
2. Click the **gear icon** (Settings) in the bottom left sidebar
3. In the left sidebar, expand **"Policy Engine"** section
4. Click the **"Policy Table"** icon (far left icon under Policy Engine)
5. Click **"Create New Policy"** button to add rules

**Direct URL:** https://192.168.1.1/network/default/settings/policy-table

**NOTE:** This is NOT under "Security" or "Firewall & Security" - those sections do not exist in Network 9.5.21+. The firewall is now managed through the Policy Engine's Policy Table interface.

#### **Key Chains**
- UBIOS_INPUT_JUMP - Input filtering
- UBIOS_FORWARD_JUMP - Inter-VLAN routing
- UBIOS_FORWARD_IN_USER - Incoming WAN traffic
- UBIOS_WAN_IN_USER - WAN firewall rules
- UBIOS_WAN_PF_IN_USER - Port forwarding rules

#### **Zone Isolation**
- DMZ → LAN: DROP
- DMZ → Guest: DROP
- DMZ → VPN: DROP
- WAN → LAN: User-defined rules + established connections
- Inter-VLAN traffic: Logged and controlled

#### **Default Behavior**
- Established/Related connections: ACCEPT
- Invalid connections: DROP
- New connections: Logged via NFLOG, then evaluated by zone rules

---

## Credentials & Access

### **SSH Access**
- **htnas02:** `ssh paschal@10.0.0.2` (passwordless SSH key recommended)
- **htnas02 (from local machine):** `ssh 10.0.0.2`
- **UDM Pro:** `ssh root@192.168.1.1` (password: [REDACTED])
- **Via Tailscale:** `ssh htnas02.tail4262ae.ts.net` or `ssh 100.114.72.82`

### **Service Access**
- **Grafana:** http://10.0.0.2:3000 or https://grafana.htnas02 (admin/[REDACTED])
- **Prometheus:** http://10.0.0.2:9090
- **Plex:** http://10.0.0.2:32499 or https://plex.htnas02
- **Dashy:** http://10.0.0.2:4000 or https://dashy.htnas02
- **Media Apps:** Via Caddy reverse proxy at *.htnas02

### **Hardware Management**
- **iDRAC:** https://192.168.1.51 (Dell server management)
- **APC UPS:** http://192.168.1.215 (UPS web interface)

### **Cloud Storage Access (rclone on htnas02)**
- **Configured Remotes:** gdrive (Google Drive), dropbox, onedrive, synology
- **List remotes:** `ssh 10.0.0.2 "rclone listremotes"`
- **List Google Drive files:** `ssh 10.0.0.2 "rclone ls gdrive:"`
- **Copy from Google Drive:** `ssh 10.0.0.2 "rclone copy gdrive:filename /tmp/"`

<<<<<<< Updated upstream
**Note:** To access Google Drive files from your local machine:
1. SSH to htnas02: `ssh paschal@10.0.0.2`
2. Use rclone commands to copy files to /tmp/
3. SCP files back to local machine: `scp paschal@10.0.0.2:/tmp/filename /tmp/`
=======
**Finding Recent Uploads (Screenshots, Images):**
- **Recent images with timestamps:** `ssh 10.0.0.2 "rclone lsl gdrive: --max-depth 1 | grep -E '\.(png|jpg|jpeg|gif)' | tail -10"`
- **Recent IMG files:** `ssh 10.0.0.2 "rclone lsl gdrive: --max-depth 1 | grep 'IMG' | tail -10"`
- **Recent Screenshot files:** `ssh 10.0.0.2 "rclone lsl gdrive: --max-depth 1 | grep -i 'screenshot' | tail -10"`
- **Important:** Most phone uploads (IMG_*, Screenshot_*) are in Google Drive root directory

**Complete Workflow to View a Google Drive File:**
```bash
# 1. Find recent files (shows size, timestamp, filename)
ssh 10.0.0.2 "rclone lsl gdrive: --max-depth 1 | grep 'IMG' | tail -10"

# 2. Copy to kube01 /tmp/
ssh 10.0.0.2 "rclone copy 'gdrive:IMG_20251130_174430.jpg' /tmp/"

# 3. Copy to local machine
scp paschal@10.0.0.2:/tmp/IMG_20251130_174430.jpg /tmp/

# 4. View the file
# Use Read tool on /tmp/IMG_20251130_174430.jpg
```

**Quick Reference:**
- Phone camera photos: `IMG_YYYYMMDD_HHMMSS.jpg` (e.g., IMG_20251130_174430.jpg)
- Android screenshots: `Screenshot_YYYYMMDD-HHMMSS.png`
- Files are typically in Google Drive root (no subdirectory)
>>>>>>> Stashed changes

---

## Quick Reference Commands

### **Container Management**
```bash
# View running containers
ssh 10.0.0.2 "podman ps"

# Restart all containers
ssh 10.0.0.2 "cd /data/appdata/compose && podman-compose restart"

# View container logs
ssh 10.0.0.2 "podman logs <container_name>"

# Manual container update
ssh 10.0.0.2 "cd /data/appdata/compose && podman-compose pull && podman-compose up -d --force-recreate"
```

### **System Monitoring**
```bash
# Check fan control status
ssh 10.0.0.2 "sudo systemctl status fanctl"

# View fan control logs
ssh 10.0.0.2 "sudo tail -f /data/ramdisk/fanctl.log"

# Check system temperatures
ssh 10.0.0.2 "sudo ipmitool sdr type temperature"

# Check disk temperatures
ssh 10.0.0.2 "sudo smartctl -A /dev/sda | grep Temperature"
```

### **Tailscale**
```bash
# Check Tailscale status
ssh 10.0.0.2 "tailscale status"

# Check network connectivity
ssh 10.0.0.2 "tailscale netcheck"
```

### **Firewall**
```bash
# Check UFW status
ssh 10.0.0.2 "sudo ufw status verbose"

# View iptables rules
ssh 10.0.0.2 "sudo iptables -L -n -v"
```

---

## Architecture Diagram

```
Internet (75.177.6.226)
    │
    ├─ UDM Pro (192.168.1.1)
    │   ├─ br0 (192.168.1.0/24) - Main LAN
    │   │   ├─ iDRAC (192.168.1.51)
    │   │   └─ APC UPS (192.168.1.215)
    │   │
    │   ├─ br10 (10.0.0.0/24) - Internal/Server
    │   │   └─ htnas02 (10.0.0.2) ─┐
    │   │                           │
    │   ├─ br2 (192.168.2.0/24) - Home Network
    │   │   ├─ XBOX
    │   │   └─ iPad
    │   │
    │   ├─ br3 (192.168.3.0/24) - Laptop Network
    │   │
    │   └─ br4 (192.168.4.0/24) - IoT Network
    │       ├─ TP-Link switches/plugs/bulbs (8+ devices)
    │       ├─ Eufy cameras (5 devices)
    │       ├─ Roku devices (2)
    │       ├─ Amazon Echo
    │       └─ Nest Hub
    │
    └─ Tailscale VPN (100.64.0.0/10)
        ├─ htnas02 (100.114.72.82) ◄─┘
        ├─ fedora (100.91.219.31)
        ├─ msvr01 (100.109.173.126)
        ├─ google-pixel-8-pro (offline)
        ├─ htnas01 (offline)
        └─ arch2 (offline)
```

---

## LFG Grafana Demo Project

### **Overview**
**Purpose:** Secure, isolated Grafana demonstration for Lincoln Financial Group (LFG) colleagues showcasing:
- Multi-location weather monitoring for LFG office locations
- Company information dashboard with stock price, executive profiles, and news
- Lincoln Financial Group branding (Maroon #8B1538, Orange #FF6B35)

**Status:** ✅ **PRODUCTION READY** (November 2025)

**Security:** Completely isolated from home lab content (Plex, *arr apps, system metrics) - safe for public viewing

### **Infrastructure**

#### **Containers**
| Container | Port | Network | Purpose |
|-----------|------|---------|---------|
| lfg-grafana | 3001 | lfg-demo (10.90.0.0/24) | Public demo dashboards (read-only, anonymous) |
| lfg-prometheus | 9092 | lfg-demo (10.90.0.0/24) | Demo metrics storage (90-day retention) |

**Network Isolation:**
- Dedicated `lfg-demo` network (10.90.0.0/24)
- No access to compose_default network (10.89.3.0/24)
- No visibility of home lab containers or metrics

#### **Access**
- **Local:** http://10.0.0.2:3001
- **Future:** https://grafana.paschal-engineering.com (requires domain purchase + Cloudflare Tunnel)

**Firewall Rules (UFW on htnas02):**
- Port 3001: Open to 192.168.1.0/24 (Main LAN), 192.168.3.0/24 (Laptop Network)
- Port 9092: Optional debug access (same networks)

**UDM Pro Firewall:**
- Policy Engine rule allows: Home Network (192.168.2.0/24) → Server Network (10.0.0.2) on ports 3001, 5678

### **Grafana Configuration**

#### **lfg-grafana Container**
- **Image:** docker.io/grafana/grafana:latest
- **Port:** 3001 (external), 3000 (internal)
- **Volumes:**
  - `/data/appdata/lfg-demo/grafana-provisioning:/etc/grafana/provisioning`
  - `/data/appdata/lfg-demo/grafana-data:/var/lib/grafana`
- **Environment:**
  - `GF_AUTH_ANONYMOUS_ENABLED=true` - Anonymous viewer mode (read-only)
  - `GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer`
  - `GF_SECURITY_ALLOW_EMBEDDING=true`
  - Editing disabled for public access

#### **Datasources**
- **Name:** LFG Prometheus
- **Type:** Prometheus
- **URL:** http://10.0.0.2:9092
- **UID:** P0A55DF077B10736D
- **Note:** Changed from `http://lfg-prometheus:9090` to avoid container DNS issues

#### **Dashboards**

**1. LFG Multi-Location Weather** (`/d/lfg-multi-location-weather`)
- **Purpose:** Real-time weather monitoring for 4 LFG office locations
- **Locations:**
  1. **Ashburn, VA** - Coordinates: 39.0437°N, 77.4875°W (Station: KIAD)
  2. **Chicago, IL** - Coordinates: 41.8781°N, 87.6298°W (Station: KORD)
  3. **Greensboro, NC** - Coordinates: 36.0726°N, 79.7920°W (Station: KGSO)
  4. **Fort Wayne, IN** - Coordinates: 41.0793°N, 85.1394°W (Station: KFWA)
- **Panels:**
  - Temperature by Location (4 stat panels with gradient backgrounds)
  - Humidity by Location (4 stat panels)
  - Temperature Trends (6h) - Time series graph showing all locations
- **Colors:** LFG Orange (#FF6B35) for temperature thresholds
- **Data Source:** National Weather Service API via n8n workflows
- **Refresh:** 5 minutes

**2. Lincoln Financial Group - Company Overview** (`/d/lfg-company-v1`)
- **Purpose:** Company information and metrics dashboard
- **Panels:**
  1. **Stock Price (LNC)** - Large stat panel showing current LNC stock price ($33.50)
     - Background color: LFG Orange (#FF6B35)
     - Currency format (USD)
     - Metric: `n8n_lfg_stock_price`
  2. **Joe Brannan - VP Core Infrastructure Services** - Text panel with markdown bio
     - Title, responsibilities, areas of focus
     - LinkedIn profile link
  3. **Company News Feed** - Recent LFG headlines and press releases
     - Strategic Partnership with Bain Capital ($825M - October 2025)
     - Leadership Appointment - John Morriss named CIO (October 2025)
     - Q3 2025 Earnings (October 30, 2025)
     - Q2/Q1 2025 Results
     - Link to newsroom
- **Colors:** LFG Orange (#FF6B35) for stock price panel
- **Refresh:** 5 minutes

#### **Branding**
**Lincoln Financial Group Colors:**
- **Maroon:** #8B1538 (used for negative/warning thresholds)
- **Orange:** #FF6B35 (used for positive values, backgrounds)

**Applied to:**
- Stock price panel background (orange)
- Temperature stat panels (blue for cold, orange for warm/high humidity)
- Dashboard styling throughout

### **Prometheus Configuration**

#### **lfg-prometheus Container**
- **Image:** docker.io/prom/prometheus:latest
- **Port:** 9092 (external), 9090 (internal)
- **Volumes:**
  - `/data/appdata/lfg-demo/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro`
  - `/data/appdata/lfg-demo/prometheus-data:/prometheus`
- **Retention:** 90 days (`--storage.tsdb.retention.time=90d`)
- **Config:** `/data/appdata/lfg-demo/prometheus/prometheus.yml`

#### **Scrape Targets**
- **Pushgateway:** http://pushgateway:9091 (main Pushgateway on compose_default network)
- **Interval:** 15 seconds

#### **Metric Filtering**
```yaml
metric_relabel_configs:
  - source_labels: [__name__]
    regex: 'n8n_(weather_.*|lfg_.*)'
    action: keep
```
**Result:** Only keeps metrics matching `n8n_weather_*` or `n8n_lfg_*` patterns

### **n8n Workflows**

#### **Weather Collection Workflows (4 total)**
All workflows run **every 5 minutes** and push metrics to Pushgateway (main instance on compose_default):

1. **LFG Weather - Ashburn, VA**
   - **Workflow ID:** `dd93930d-4729-4ad3-a8cc-f3e0c9e3d691`
   - **Coordinates:** 39.0437°N, 77.4875°W
   - **Grid Point:** LWX/95,71
   - **Station:** KIAD (Washington Dulles International Airport)
   - **Metrics:** `n8n_weather_temperature_f`, `n8n_weather_humidity_percent`, `n8n_weather_wind_speed_mph`
   - **Labels:** `location="Ashburn, VA"`

2. **LFG Weather - Chicago, IL**
   - **Workflow ID:** `c256fcb1-224b-4917-b052-03d917101ca4`
   - **Coordinates:** 41.8781°N, 87.6298°W
   - **Grid Point:** LOT/76,74
   - **Station:** KORD (O'Hare International Airport)
   - **Metrics:** Same as above with `location="Chicago, IL"`

3. **LFG Weather - Greensboro, NC**
   - **Workflow ID:** `668f9021-0574-42d9-b399-072ed8df1135`
   - **Coordinates:** 36.0726°N, 79.7920°W
   - **Grid Point:** RAH/73,75
   - **Station:** KGSO (Piedmont Triad International Airport)
   - **Metrics:** Same as above with `location="Greensboro, NC"`

4. **LFG Weather - Fort Wayne, IN**
   - **Workflow ID:** `1f710a1b-785c-4d13-858f-34e973fed72a` (formerly Lincoln, NE)
   - **Coordinates:** 41.0793°N, 85.1394°W
   - **Grid Point:** IWX/69,38
   - **Station:** KFWA (Fort Wayne International Airport)
   - **Metrics:** Same as above with `location="Fort Wayne, IN"`

**Note:** Originally configured for Lincoln, NE but changed to Fort Wayne, IN per user correction that "Lincoln" refers to Lincoln Financial Group (the company), not Lincoln, Nebraska.

#### **Stock Price Workflow (Future)**
- **Metric:** `n8n_lfg_stock_price`
- **Current Status:** Sample data ($33.50) hardcoded for demo
- **Future Implementation:** Real-time stock API (Alpha Vantage, Finnhub, or similar)
- **Update Frequency:** Every 15 minutes (market hours only)

### **File Locations**

#### **Main Configuration**
- **Grafana Provisioning:** `/data/appdata/lfg-demo/grafana-provisioning/`
  - Datasources: `datasources/prometheus.yml`
  - Dashboards: `dashboards/weather.json`, `dashboards/lfg-company-dashboard.json`
  - Dashboard Config: `dashboards/dashboard.yml`
- **Prometheus Config:** `/data/appdata/lfg-demo/prometheus/prometheus.yml`
- **Documentation:** `/data/appdata/lfg-demo/LFG-DEMO-DOCUMENTATION.md`

#### **Data Storage**
- **Grafana Data:** `/data/appdata/lfg-demo/grafana-data/`
- **Prometheus Data:** `/data/appdata/lfg-demo/prometheus-data/`

#### **Python Branding Script**
- **Location:** `/tmp/apply-branding.py`
- **Purpose:** Applies LFG brand colors (#8B1538, #FF6B35) to dashboard thresholds
- **Usage:** Run after dashboard modifications to ensure consistent branding

### **Known Issues and Solutions**

#### **Issue 1: Datasource UID Mismatch**
- **Symptom:** Dashboards show "No Data" despite metrics in Prometheus
- **Root Cause:** Dashboards referenced `"uid": "prometheus"` but actual UID was `"P0A55DF077B10736D"`
- **Solution:** Updated all dashboard JSON files to use correct UID
- **Prevention:** Always verify datasource UID matches provisioned datasource

#### **Issue 2: Container DNS Resolution**
- **Symptom:** lfg-grafana couldn't reach lfg-prometheus via container name
- **Root Cause:** lfg-demo network DNS not resolving container names reliably
- **Solution:** Changed datasource URL from `http://lfg-prometheus:9090` to `http://10.0.0.2:9092`
- **Note:** Using host IP bypasses container DNS entirely

#### **Issue 3: n8n Workflow Expression Errors**
- **Symptom:** Workflow fails with "invalid syntax" when trying to pass data between nodes
- **Root Cause:** n8n expression syntax is complex and error-prone
- **Solution:** Hardcoded API URLs directly in HTTP Request nodes instead of using expressions
- **Example:** `https://api.weather.gov/stations/KFWA/observations/latest` (instead of dynamic URL)

#### **Issue 4: Metric Naming Convention**
- **Symptom:** Metrics not appearing in lfg-prometheus despite being in main Prometheus
- **Root Cause:** Metric filtering requires `n8n_` prefix
- **Solution:** Renamed all metrics to include `n8n_` prefix (e.g., `lfg_stock_price` → `n8n_lfg_stock_price`)

#### **Issue 5: Markdown Formatting in Text Panels**
- **Symptom:** Joe Brannan bio showing literal `\n` characters instead of line breaks
- **Root Cause:** Escaped newlines in JSON causing literal text rendering
- **Solution:** Rewrote markdown content using Python triple-quoted strings for proper formatting
- **Fix Applied:** Updated `/data/appdata/lfg-demo/grafana-provisioning/dashboards/lfg-company-dashboard.json`

#### **Issue 6: Lincoln, Nebraska vs Lincoln Financial Group**
- **Critical Misunderstanding:** Initially built dashboards for Lincoln, NE (city) instead of Lincoln Financial Group (company)
- **Impact:** Created Nebraska Huskers sports dashboard, Lincoln NE city statistics, air quality data
- **Correction:** Deleted all Nebraska-specific workflows and replaced with LFG company data
- **Lesson:** Always clarify "Lincoln" refers to the **company** (Lincoln Financial Group), NOT the city

### **Future Enhancements**

#### **Public Access (Planned)**
1. **Domain Purchase:** paschal-engineering.com
2. **Cloudflare Tunnel:** Configure tunnel to lfg-grafana container
3. **SSL Certificate:** Let's Encrypt via Cloudflare
4. **Public URL:** https://grafana.paschal-engineering.com
5. **Security:** Already configured for anonymous viewer mode (read-only)

#### **Additional Data Sources**
- **Real-time Stock API:** Replace sample $33.50 with live LNC stock data
- **Company News Feed:** Automated n8n workflow scraping LFG newsroom
- **Executive Profiles:** Additional VPs and leadership team members
- **Office Photos:** Static images or photo galleries for each location

#### **Dashboard Improvements**
- **Map Panel:** Interactive map showing all 4 LFG office locations
- **Weather Alerts:** NWS alerts/warnings for each location
- **Historical Comparison:** Year-over-year weather trends
- **Stock Performance:** Historical price charts, market cap, P/E ratio

### **Maintenance**

#### **Container Management**
```bash
# Restart LFG Grafana demo stack
ssh 10.0.0.2 "podman restart lfg-grafana lfg-prometheus"

# View logs
ssh 10.0.0.2 "podman logs lfg-grafana"
ssh 10.0.0.2 "podman logs lfg-prometheus"

# Check metrics in Prometheus
curl -s http://10.0.0.2:9092/api/v1/query?query=n8n_weather_temperature_f | jq
curl -s http://10.0.0.2:9092/api/v1/query?query=n8n_lfg_stock_price | jq
```

#### **Dashboard Updates**
```bash
# Apply LFG branding colors to dashboards
ssh 10.0.0.2 "python3 /tmp/apply-branding.py"

# Restart Grafana to reload dashboards
ssh 10.0.0.2 "podman restart lfg-grafana"
```

#### **n8n Workflow Management**
```bash
# Access n8n web interface
# URL: https://n8n.htnas02 (via Caddy reverse proxy)

# Check workflow execution logs in n8n UI
# Navigate to Executions tab for each workflow
```

### **Security Hardening**

#### **Implemented**
- ✅ Dedicated isolated network (lfg-demo)
- ✅ Anonymous viewer mode (no login required, read-only)
- ✅ Editing disabled for public users
- ✅ Metric filtering (only `n8n_weather_*` and `n8n_lfg_*` metrics)
- ✅ 90-day data retention (limited exposure of historical data)
- ✅ UFW firewall rules limiting access to specific networks
- ✅ UDM Pro inter-VLAN firewall rules

#### **Recommended for Public Deployment**
- [ ] Rate limiting on public URL (via Cloudflare)
- [ ] DDoS protection (Cloudflare proxy)
- [ ] HTTPS with valid Let's Encrypt certificate
- [ ] Security headers (CSP, HSTS, X-Frame-Options)
- [ ] Monitoring for suspicious access patterns
- [ ] Regular security audits of exposed data

### **Documentation References**
- **Project Documentation:** `/data/appdata/lfg-demo/LFG-DEMO-DOCUMENTATION.md`
- **n8n Workflows:** See "n8n Automation" section above (workflows 1-4)
- **Grafana Dashboards:** Available at http://10.0.0.2:3001
- **Python Branding Script:** `/tmp/apply-branding.py`

---

**End of Documentation**

---

## Paschal Engineering Business Infrastructure

### **Overview**
**Established:** 2025-11-27  
**Purpose:** AI Consulting & Infrastructure Automation company  
**GitHub:** https://github.com/dpaschal/paschal-engineering  
**Status:** Infrastructure complete, DNS propagating

### **Domains (Cloudflare)**
- **paschal-engineering.com** - Main consulting site
- **paschal-engineering.ai** - AI innovation lab  
- **paschal-enterprises.com** - Parent company
- **Status:** All registered, CNAME records configured, DNS propagating (24-48 hours)

### **Cloudflare Tunnel**
- **Tunnel ID:** 32b733d0-5fd1-43cd-a12f-240e10536c48
- **Service:** cloudflared.service (systemd)
- **Status:** Active, running on htnas02
- **Protocol:** QUIC (encrypted, fast)
- **SSL:** Automatic Let's Encrypt certificates via Cloudflare

**Ingress Routes:**
```
paschal-engineering.com → localhost:31337 (nginx)
paschal-engineering.ai → localhost:36410 (nginx)
paschal-enterprises.com → localhost:19840 (nginx)
/lincoln-demo/* → 10.0.0.2:3001 (lfg-grafana)
```

**Config Location:** `/etc/cloudflared/config.yml`  
**Credentials:** `/etc/cloudflared/32b733d0-5fd1-43cd-a12f-240e10536c48.json` (mode 600)

**Security Features:**
- Zero WAN port exposure
- Cloudflare DDoS protection
- Non-standard backend ports (31337, 36410, 19840)
- Automatic SSL/TLS

### **Website Server (nginx)**
- **Container:** paschal-websites (nginx:alpine)
- **Network Mode:** host
- **Ports:**
  - 31337 - paschal-engineering.com (elite/leet port)
  - 36410 - paschal-engineering.ai (FidoNet node 3641:0 reference)
  - 19840 - paschal-enterprises.com (1984 BBS era reference)
- **Content:** `/data/appdata/websites/`
- **Status:** Running, serving BBS-style placeholder pages

**Security:**
- Read-only volume mounts
- Non-standard high ports
- Localhost binding only (accessed via Cloudflare Tunnel)

### **Repository Structure**
```
/data/appdata/paschal-engineering/
├── README.md                          # Company overview
├── websites/                          # Website HTML/CSS/JS
│   ├── paschal-engineering.com/
│   ├── paschal-engineering.ai/
│   └── paschal-enterprises.com/
├── infrastructure/                    # Infrastructure configs
│   ├── cloudflare-tunnel/
│   ├── nginx/
│   └── grafana/
├── services/                          # Client demos
│   └── lfg-demo/                     # Lincoln Financial demo
├── docs/                              # Documentation
│   ├── PROGRESS.md                   # Project tracking
│   └── SECURITY-AUDIT.md             # Security analysis
├── branding/                          # Logos & design
└── config/                            # Configuration templates
```

**Git Remote:** git@github.com:dpaschal/paschal-engineering.git
**SSH Key:** `/home/paschal/.ssh/id_ed25519.pub` (added to GitHub)

### **Cloudflare API Access**
**API Token (Edit zone DNS):** `[REDACTED-CLOUDFLARE-TOKEN]`
**Account Email:** dpaschal@gmail.com
**Permissions:** Zone.DNS:Edit, Zone.Zone:Read, Account Settings:Read
**Scope:** All accounts, All zones
**Last Rolled:** 2025-11-27 03:07 UTC

### **Brand Identity**
- **Logo:** /// (three forward slashes) in neon green
- **Colors:** 
  - Primary: #00FF41 (WYSE terminal phosphor green)
  - Background: #000000 (black)
  - Accent: #00FFFF (cyan), #FFB000 (amber)
- **Aesthetic:** 1980s BBS/FidoNet era, WYSE terminals, monospace fonts
- **Node Reference:** 1:3641/100 (FidoNet-style addressing)

### **Services Offered**
1. **Infrastructure Monitoring & Observability**
   - Grafana dashboards
   - Prometheus metrics
   - n8n automation

2. **AI Integration & Automation**
   - Self-hosted AI models (Ollama)
   - RAG systems
   - Custom AI agents

3. **Cloud-Native Architecture**
   - Containerization
   - Infrastructure as Code
   - Edge computing

### **Security Audit Results**
**Score:** 8.5/10 (Strong)

**Strengths:**
- ✅ Cloudflare Tunnel (zero WAN exposure)
- ✅ Non-standard ports
- ✅ Tailscale not advertising subnets
- ✅ UFW restrictive rules
- ✅ Network isolation for lfg-demo

**Action Items:**
- Enable Tailnet Lock (prevents unauthorized devices)
- Remove legacy UFW rules (ports 8180, 8181, 8143)
- Document UDM Pro Policy Table rules
- Clean up offline Tailscale devices

**Full Audit:** `/data/appdata/paschal-engineering/docs/SECURITY-AUDIT.md`

### **Future Tasks**
- [ ] Get Google Voice business number
- [ ] Design /// neon green logos (BBS/FidoNet aesthetic)
- [ ] Build full BBS-style landing pages with ANSI art
- [ ] Test all sites once DNS propagates
- [ ] Create AI lab demos on paschal-engineering.ai
- [ ] Build service offering pages
- [ ] Set up business email (@paschal-engineering.com)

### **Important Notes**
- **DNS Propagation:** 24-48 hours typical for global propagation
- **Private Tracking:** All progress documented in GitHub repo PROGRESS.md
- **Security:** Comprehensive audit completed, scored 8.5/10
- **Next Session:** Test live sites, design logos, build landing pages

---

**/// PASCHAL-ENGINEERING INFRASTRUCTURE DOCUMENTED**
**Last Business Update:** 2025-11-27 06:25 UTC
