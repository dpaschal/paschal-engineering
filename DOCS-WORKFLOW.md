# Documentation Workflow

This repository uses MkDocs with Material theme to generate beautiful static documentation. Changes follow a dev→prod promotion workflow.

## Branch Structure

- **`dev`** - NON-PROD branch for testing changes
  - Served at: `https://docs-dev.htnas02` (password protected)
  - Always work in this branch first

- **`main`** - PROD branch for published documentation
  - Served at: `https://docs.htnas02` (public)
  - Only merge from dev after review

## Quick Start

### Making Documentation Changes

```bash
# 1. Ensure you're on dev branch
cd /data/appdata/paschal-engineering
git checkout dev
git pull origin dev

# 2. Make your changes to markdown files in docs/
vim docs/LESSONS-LEARNED.md

# 3. Commit changes
git add docs/
git commit -m "Update lessons learned with new issue"

# 4. Push to dev
git push origin dev

# 5. Rebuild and deploy to DEV site
./build-and-deploy.sh dev

# 6. Review at https://docs-dev.htnas02 (username: admin)

# 7. If it looks good, merge to prod
git checkout main
git pull origin main
git merge dev
git push origin main

# 8. Deploy to PROD
./build-and-deploy.sh prod
```

## File Structure

```
paschal-engineering/
├── mkdocs.yml              # MkDocs configuration
├── Dockerfile.docs         # Multi-stage build for docs
├── nginx.conf             # Nginx config for serving site
├── build-and-deploy.sh    # Deployment script
├── docs/                  # Markdown source files
│   ├── index.md          # Homepage
│   ├── LESSONS-LEARNED.md # Knowledge base
│   ├── myenvironment.md   # Infrastructure docs
│   ├── PROGRESS.md        # Project tracking
│   ├── TODO.md            # Task list
│   └── ...               # Other markdown files
└── site/                 # Generated static site (git-ignored)
```

## MkDocs Configuration

The `mkdocs.yml` file controls:
- Site metadata (name, description, repo URL)
- Theme settings (Material with dark/light mode)
- Navigation structure
- Markdown extensions (code highlighting, admonitions, tables, etc.)
- Plugins (search, git revision dates)

## Adding New Pages

1. Create markdown file in `docs/` directory
2. Add to `nav` section in `mkdocs.yml`:

```yaml
nav:
  - Home: index.md
  - Knowledge Base:
      - Overview: LESSONS-LEARNED.md
      - New Page: new-page.md  # Add here
```

3. Commit, push, rebuild

## Markdown Features

MkDocs Material supports rich markdown features:

### Code Blocks with Syntax Highlighting

\`\`\`python
def hello_world():
    print("Hello, World!")
\`\`\`

### Admonitions (Callouts)

\`\`\`
!!! note "This is a note"
    Important information goes here.

!!! warning "Warning"
    Be careful!

!!! danger "Critical"
    This is dangerous!
\`\`\`

### Tables

| Column 1 | Column 2 |
|----------|----------|
| Data     | More data|

### Tabs

\`\`\`
=== "Tab 1"
    Content for tab 1

=== "Tab 2"
    Content for tab 2
\`\`\`

## Deployment Details

### Container Build Process

The `Dockerfile.docs` uses multi-stage build:

1. **Builder stage**: Installs Python, MkDocs, plugins, builds static site
2. **Production stage**: Nginx Alpine serves the generated static files

### Port Mapping

- `docs-dev` → `http://192.168.4.144:8083` → `https://docs-dev.htnas02` (basic auth)
- `docs-prod` → `http://192.168.4.144:8084` → `https://docs.htnas02` (public)

### Caddy Configuration

Add to `/data/appdata/caddy/Caddyfile`:

```
# Documentation - DEV (password protected)
docs-dev.htnas02 {
    log {
        output stdout
    }
    tls /etc/caddy/cert.pem /etc/caddy/key.pem
    basicauth {
        admin <bcrypt-hash>
    }
    reverse_proxy docs-dev:80
}

# Documentation - PROD (public)
docs.htnas02 {
    log {
        output stdout
    }
    tls /etc/caddy/cert.pem /etc/caddy/key.pem
    reverse_proxy docs-prod:80
}
```

Generate password hash:
```bash
podman exec -it caddy caddy hash-password --plaintext 'your-password'
```

### Podman Compose Entry

Add to `/data/appdata/compose/podman-compose.yml`:

```yaml
  # Documentation - DEV (basic auth protected)
  docs-dev:
    build:
      context: /data/appdata/paschal-engineering
      dockerfile: Dockerfile.docs
    image: localhost/docs:dev
    container_name: docs-dev
    restart: unless-stopped
    ports:
      - "8083:80"

  # Documentation - PROD (public)
  docs-prod:
    build:
      context: /data/appdata/paschal-engineering
      dockerfile: Dockerfile.docs
    image: localhost/docs:prod
    container_name: docs-prod
    restart: unless-stopped
    ports:
      - "8084:80"
```

## Troubleshooting

### Build fails
```bash
# Check build logs
podman build -t docs:dev -f Dockerfile.docs .

# Test locally without container
cd /data/appdata/paschal-engineering
pip install mkdocs mkdocs-material mkdocs-git-revision-date-localized-plugin
mkdocs serve
# Visit http://localhost:8000
```

### Site doesn't update
```bash
# Force rebuild without cache
podman build --no-cache -t docs:dev -f Dockerfile.docs .
podman-compose restart docs-dev
```

### Basic auth not working
```bash
# Regenerate password hash
podman exec -it caddy caddy hash-password

# Update Caddyfile with new hash
# Reload Caddy
podman exec -it caddy caddy reload --config /etc/caddy/Caddyfile
```

## Best Practices

1. **Always test in dev first** - Never commit directly to main
2. **Write descriptive commit messages** - Others need to understand changes
3. **Update this workflow doc** - If you improve the process, document it
4. **Use relative links** - `[link](other-page.md)` not absolute URLs
5. **Keep navigation organized** - Group related pages in mkdocs.yml
6. **Add revision dates** - Plugin automatically shows last-modified dates

## Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Markdown Guide](https://www.markdownguide.org/)
