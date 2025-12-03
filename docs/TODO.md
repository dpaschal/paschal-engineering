# Paschal Engineering - Master To-Do List

**Last Updated:** 2025-11-27 06:30 UTC  
**Status:** All-nighter in progress 🚀

---

## 🚨 CRITICAL - Do Immediately

### Legal & Compliance
- [ ] **Review LFG employment contract** for conflict of interest clauses
  - Check non-compete terms
  - Check IP ownership clauses
  - Check outside business activity policies
- [ ] **Disclose side business to LFG HR** (if required by contract)
- [ ] **Avoid targeting financial services industry** (too close to LFG)

### Security Hardening (IN PROGRESS)
- [x] Enable Tailnet Lock - DONE (already enabled)
- [x] Remove legacy UFW Traefik rules (8180, 8181, 8143) - DONE
- [x] Remove legacy DNS forwarding rule (port 53/podman1) - DONE
- [ ] Remove offline Tailscale devices (arch2, pixel, htnas01)
  - Go to: https://login.tailscale.com/admin/machines
  - Disable each offline device
- [ ] **Manual UDM Pro Policy Table audit** - IN PROGRESS
  - https://192.168.1.1 → Settings → Policy Engine → Policy Table
  - Verify lfg-demo network isolation
  - Document all firewall rules
  - Screenshot Policy Table

---

## 🏢 Business Setup

### Branding & Identity
- [ ] **Search USPTO trademark database** for "Paschal Engineering"
  - https://www.uspto.gov/trademarks
  - Cost: ~$250-350 per class if filing
- [ ] **Design /// neon green logo** (BBS/FidoNet aesthetic)
  - Primary: #00FF41 (WYSE terminal green)
  - Monospace fonts
  - Three forward slashes motif
  - Network topology elements
- [ ] **Add © 2025 Paschal Enterprises** to all websites

### Business Operations
- [ ] **Get Google Voice business number**
  - Search for memorable number (maybe with 3641 in it)
  - Cost: $10/month for additional line
- [ ] **Set up business email** (@paschal-engineering.com)
- [ ] **Create cost tracking spreadsheet**
  - Domains: ~$30/year
  - Google Voice: ~$10/month
  - Infrastructure: $0 (using kube01)
- [ ] **Define target markets** (avoid financial services)
  - Healthcare tech
  - Manufacturing/industrial
  - Retail/e-commerce
  - SaaS startups
  - Government/education

---

## 🌐 Website Development

### DNS & Infrastructure
- [x] Register paschal-engineering.com - DONE
- [x] Register paschal-engineering.ai - DONE
- [x] Register paschal-enterprises.com - DONE
- [x] Configure Cloudflare Tunnel - DONE
- [x] Set up nginx web server (ports 31337, 36410, 19840) - DONE
- [ ] **Wait for DNS propagation** (24-48 hours)
- [ ] **Test all public URLs** once DNS propagates
  - https://paschal-engineering.com
  - https://paschal-engineering.com/lincoln-demo
  - https://paschal-engineering.ai
  - https://paschal-enterprises.com

### Landing Pages
- [ ] **Build full BBS-style landing page** for paschal-engineering.com
  - ANSI art header with /// logo
  - Typewriter text effects
  - Interactive menu system
  - Blinking cursor
  - "Last 10 callers" list (fake/demo data)
  - Modem connect sounds (optional)
  - Links to services, LFG demo, contact
- [ ] **Build AI lab page** for paschal-engineering.ai
  - Similar BBS aesthetic but futuristic
  - "NEURAL NETWORK STATUS: ACTIVE"
  - Showcase Ollama capabilities
  - Demo projects/tools
- [ ] **Build parent company page** for paschal-enterprises.com
  - Corporate BBS style
  - About the umbrella organization
  - Vision and mission

### Content Creation
- [ ] **Write service offerings page**
  - Infrastructure Monitoring & Observability
  - AI Integration & Automation
  - Cloud-Native Architecture
- [ ] **Document LFG demo case study**
  - Challenge, Solution, Results format
  - Professional writeup
  - Screenshots
- [ ] **Create contact form** (or contact info page)
- [ ] **Write About page** (your background, expertise)

---

## 🤖 AI Lab Development

### Ollama Showcases
- [ ] **Create live AI demo** on paschal-engineering.ai
  - Chatbot interface
  - RAG system demonstration
  - Model benchmarks
- [ ] **Document self-hosted AI setup**
  - Ollama installation guide
  - Model performance comparisons
  - Privacy benefits vs cloud APIs
- [ ] **Build AI tools showcase**
  - Custom agents
  - Automation examples
  - Integration demos

---

## 📊 LFG Demo Enhancements

- [ ] **Add more dashboards** to LFG demo
  - Expand weather data
  - Add more company metrics
  - Additional executive profiles
- [ ] **Implement real-time stock price API**
  - Replace sample $33.50 with live data
  - Alpha Vantage or Finnhub
- [ ] **Create automated news feed workflow** (n8n)
  - Scrape LFG newsroom
  - Update dashboard automatically
- [ ] **Document the entire setup** in case study format

---

## 💼 Marketing & Sales

### Service Definition
- [ ] **Define pricing models**
  - Hourly consulting
  - Project-based
  - Retainer agreements
- [ ] **Create service packages**
  - Starter (small business)
  - Professional (mid-market)
  - Enterprise (large companies)
- [ ] **Write value propositions** for each service
- [ ] **Create competitor analysis**
  - Who else does this?
  - What makes Paschal Engineering different?

### Marketing Materials
- [ ] **Design business cards**
  - BBS aesthetic
  - Include /// logo
  - QR code to website
- [ ] **Create presentation template**
  - For client pitches
  - Case studies
  - Service overview
- [ ] **Write elevator pitch** (30 seconds)
- [ ] **Write cold outreach templates**

---

## 🔐 Ongoing Security

### Regular Audits
- [ ] **Schedule quarterly security audits**
- [ ] **Set up automated vulnerability scanning**
- [ ] **Create security monitoring dashboard** in Grafana
- [ ] **Enable UFW logging** for blocked attempts
- [ ] **Review Tailscale device list monthly**

### Cloudflare Hardening
- [ ] **Enable Cloudflare rate limiting** (optional)
- [ ] **Enable Cloudflare WAF rules** (optional)
- [ ] **Set up Cloudflare bot protection**
- [ ] **Monitor tunnel metrics** (127.0.0.1:20241/metrics)

---

## 📚 Documentation

### GitHub Repository
- [x] Create GitHub repo - DONE
- [x] Push initial commit - DONE
- [x] Create README.md - DONE
- [x] Create PROGRESS.md - DONE
- [x] Create SECURITY-AUDIT.md - DONE
- [ ] **Sync this to-do.md to GitHub** as docs/TODO.md
- [ ] **Create ARCHITECTURE.md** - System design documentation
- [ ] **Create DEPLOYMENT.md** - How to replicate the setup
- [ ] **Add LICENSE file** (if making anything open source)

### myenvironment.md
- [x] Add Paschal Engineering section - DONE
- [ ] **Update after each major change**
- [ ] **Document all UDM Pro firewall rules**
- [ ] **Add business contact information** once established

---

## 🎯 Roadmap

### Week 1 (This Week)
- Complete security hardening
- Finish website landing pages
- Test all public URLs
- Get business number
- Review legal/compliance

### Month 1
- Complete AI lab demos
- Finish LFG case study
- Create marketing materials
- Define pricing and services
- Start outreach (if no LFG conflict)

### Month 3
- First paying client
- Expand service offerings
- Build additional case studies
- Refine processes

### Month 6
- Multiple clients
- Consider LLC formation
- Hire first contractor (if needed)
- Expand infrastructure capabilities

---

## 💭 Ideas & Notes

(This is where your pasted text will go)

---

**/// TO-DO LIST MAINTAINED - TRACKING PROGRESS**

## 🚀 PROJECT IDEAS - In Progress

### 1. Dell R630 Kubernetes Home Server
**Status:** Planning / Setup Phase

**Goal:** Repurpose spare Dell R630 as a Kubernetes cluster for self-hosted homelab infrastructure

**Tasks:**
- [ ] Download Flatcar Container Linux ISO
- [ ] Create Ignition config for automated setup
- [ ] Copy to Ventoy USB (bootable)
- [ ] Use Claude Code to manage entire deployment
- [ ] Spin up all services via Claude Code automation
- [ ] Migrate appropriate workloads from kube01 to K8s cluster

**Tech Stack:**
- Base OS: Flatcar Container Linux
- Orchestration: Kubernetes
- Automation: Claude Code-driven

**Benefits:**
- Learn Kubernetes hands-on
- More scalable than current Podman setup
- Professional skillset development
- Could become a service offering (K8s consulting)

---

### 2. Amiga-Style Sine Scroller Demo
**Status:** Planning Phase

**Goal:** Write old-school Assembly demoscene sine scroller (Euro demoscene / Amiga era)

**Inspiration:**
- Assembly (demoparty)
- Future Crew
- Fairlight
- Kefrens
- Classic copper bar aesthetics

**Tasks:**
- [ ] Stand up Linux container for Assembly development
- [ ] Set up assembler toolchain (NASM/YASM)
- [ ] Research Amiga sine scroller techniques
- [ ] Implement smooth scrolling text with sine wave motion
- [ ] Add copper bar effects
- [ ] Deploy on paschal-engineering.ai as interactive demo

**Tech Details:**
- Language: x86/x64 Assembly
- Graphics: Software rendering or SDL2
- Style: 320x200 chunky pixels, palette cycling
- Music: Tracker modules (optional)

**Why This is AMAZING:**
- Shows low-level programming skills
- Nostalgia appeal (demoscene aesthetic)
- Perfect for paschal-engineering.ai "retro computing" vibe
- Could become a client demo (embedded systems expertise)

---

### 3. "Conspiracy Board" Research Tool
**Status:** Concept Phase

**Goal:** Visual connection/relationship mapping tool (detective string board style)

**Use Cases:**
- Research complex relationships
- Map business connections
- Investigate data patterns
- Link entities, events, documents

**Tasks:**
- [ ] Choose graph database backend
  - Neo4j (mature, powerful)
  - ArangoDB (multi-model)
  - Or lightweight: TinkerPop/Gremlin
- [ ] Design web UI (visual graph interface)
  - Drag-and-drop nodes
  - Draw connections
  - Add notes/evidence
- [ ] Implement search and filtering
- [ ] Deploy as containerized service
- [ ] Consider making it a SaaS product

**Potential Business Angle:**
- Consulting firms need relationship mapping
- Legal teams track case connections
- Journalists investigate stories
- Security analysts map threat actors
- Could be a standalone product offering

---

### 4. AI Rome Web Series for YouTube
**Status:** Planning Phase

**Goal:** AI-generated web series showcasing Rome for your brother to experience virtually

**Tasks:**
- [ ] Research Rome locations (Colosseum, Vatican, Trevi Fountain, etc.)
- [ ] Generate AI video/imagery of Roman sites
  - Stable Diffusion for images
  - AI video generation (Runway, Pika, etc.)
  - Or: Use existing footage + AI narration
- [ ] Write scripts for each episode
  - History of each location
  - Virtual walking tours
  - Cultural context
- [ ] Generate AI voiceover (ElevenLabs, Ollama TTS)
- [ ] Edit into YouTube series format
- [ ] Upload to YouTube channel

**Episode Ideas:**
1. The Colosseum - Gladiator Arena
2. Vatican City - Art & Architecture
3. Roman Forum - Ancient Government
4. Trevi Fountain - Baroque Beauty
5. Pantheon - Engineering Marvel
6. Sistine Chapel - Michelangelo's Masterpiece

**Tech Stack:**
- AI Image: Stable Diffusion, Midjourney
- AI Video: Runway ML, Pika Labs
- AI Voice: ElevenLabs, Coqui TTS, Ollama
- Editing: DaVinci Resolve, FFmpeg

**Why This Matters:**
- Demonstrates AI capabilities
- Showcase for paschal-engineering.ai
- Portfolio piece for AI consulting
- Personal gift for family

---

### 5. Budget AI Server Research (Dell/HP)
**Status:** Research Phase

**Goal:** Find affordable next-generation server for AI/LLM hosting with Ollama

**Requirements:**
- GPU support (NVIDIA preferred for CUDA)
- Sufficient RAM for large models (64GB+ minimum)
- NVMe storage for model loading speed
- Power efficiency (avoid high electricity costs)
- Budget-friendly (used/refurbished acceptable)
- Can run all current kube01 workloads PLUS Ollama

**Options to Research:**
- [ ] Dell PowerEdge R740 (2U, dual Xeon, GPU support)
- [ ] Dell PowerEdge R640 (1U, dual Xeon)
- [ ] HP ProLiant DL380 Gen10 (2U, popular choice)
- [ ] Dell Precision 7920 Tower (workstation, better GPU support)
- [ ] Supermicro GPU servers (best price/performance)
- [ ] Consider: AMD EPYC vs Intel Xeon for AI workloads

**GPU Considerations:**
- NVIDIA RTX 4090 (best but expensive: ~$1600)
- NVIDIA RTX 3090 (older but cheaper: ~$800 used)
- NVIDIA A4000/A5000 (professional, efficient)
- AMD Instinct MI210 (alternative to NVIDIA)
- Check: PCIe slot compatibility (x16 for GPU)

**Memory Requirements for Ollama:**
| Model Size | RAM Needed | Example Models |
|------------|------------|----------------|
| 7B params | 8GB | Llama 3.2, Mistral |
| 13B params | 16GB | Llama 2 13B |
| 70B params | 64GB+ | Llama 3.1 70B |
| 405B params | 256GB+ | Llama 3.1 405B |

**Power & Cost Analysis:**
- Current R630 power draw: ~300W idle, ~500W load
- Target new server: <400W under AI load
- Electricity cost: Calculate $/month at current rates
- ROI: How much can be saved vs cloud AI API costs?

**Output:**
- Create comparison spreadsheet
- Calculate TCO (total cost of ownership)
- Make recommendation based on budget
- Consider selling R630 to offset cost

---

### 6. Streaming Device Research
**Status:** Research Phase

**Goal:** Find best 4K streaming devices with 5GHz+ WiFi support

**Requirements:**
- 4K resolution support
- 5GHz WiFi (or WiFi 6/6E)
- Low latency
- Good codec support

**Options to Research:**
- [ ] NVIDIA Shield TV Pro (best overall)
- [ ] Apple TV 4K (ecosystem lock-in but excellent)
- [ ] Roku Ultra (budget-friendly)
- [ ] Amazon Fire TV Cube (Alexa integration)
- [ ] Google Chromecast with Google TV 4K
- [ ] DIY: Raspberry Pi 5 + LibreELEC

**Comparison Matrix:**
| Device | 4K | WiFi 6 | Price | Codec Support | Notes |
|--------|-----|--------|-------|---------------|-------|
| NVIDIA Shield TV Pro | ✅ | ✅ | $200 | Excellent | Best for power users |
| Apple TV 4K | ✅ | ✅ | $130 | Good | Apple ecosystem |
| Roku Ultra | ✅ | ⚠️ (5GHz) | $100 | Good | Budget pick |

**Output:**
- Create comparison guide
- Publish on paschal-engineering.com blog (future)
- Use as content marketing

---

## 🔗 Project Interconnections

**How These Tie Together:**

1. **K8s Cluster** → Infrastructure for all other projects
   - Host Conspiracy Board
   - Run AI Rome rendering jobs
   - Demoscene dev environment

2. **Demoscene Scroller** → Portfolio piece for paschal-engineering.ai
   - Shows low-level coding skills
   - Retro aesthetic matches BBS branding
   - Interactive demo for visitors

3. **Conspiracy Board** → Potential SaaS product
   - Could be first commercial offering
   - Solves real problem for researchers
   - Demonstrates graph database expertise

4. **AI Rome Series** → Marketing content
   - Showcases AI capabilities
   - YouTube channel for brand awareness
   - Drives traffic to paschal-engineering.ai

5. **Streaming Research** → Content marketing
   - Blog post comparing devices
   - SEO traffic to website
   - Establishes expertise

---

**All projects feed into Paschal Engineering's mission: Demonstrate technical excellence through real projects.**

