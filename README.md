# 🐘 PostgreSQL 18 LTS with PostGIS & pgvector

[![CI/CD Build](https://github.com/devxhub/postgres/actions/workflows/docker-build.yml/badge.svg)](https://github.com/YOUR_ORG/YOUR_REPO/actions/workflows/docker-build.yml)
[![GHCR Packages](https://img.shields.io/badge/GHCR-Ready-blue)](https://github.com/YOUR_ORG/YOUR_REPO/packages)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-336791?logo=postgresql)](https://www.postgresql.org/)

A production-grade, self-updating PostgreSQL container image purpose-built for spatial data (PostGIS) and AI/LLM vector embeddings (pgvector). 

This repository heavily prioritizes security, automation, and performance by utilizing the official Debian Bookworm base and automating patch management via GitHub Actions and Dependabot.

## 📦 Features

* **PostgreSQL 18 LTS:** Built on the official `postgres:18-bookworm` base.
* **Pre-compiled Extensions:** Uses the official PGDG APT repository to install `postgis` and `pgvector` natively (no brittle source compilations).
* **Auto-Initialization:** Extensions are automatically created in the default database upon first boot.
* **Zero-Touch Maintenance:** Dependabot listens for minor releases and security patches to the base image and automatically triggers our CI/CD pipeline to rebuild and push the updated image.
* **GHCR Native:** Hosted on the GitHub Container Registry (`ghcr.io`) for high availability and zero rate-limiting during CI/CD pulls.

## 🚀 Usage

You can pull the image directly from the GitHub Container Registry. 

### Docker Compose

Create a `docker-compose.yml` file:

```yaml
services:
  db:
    image: ghcr.io/devxhub/postgres:18
    restart: always
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mysecretpassword
      POSTGRES_DB: mydatabase
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:

```

Run the stack:

```bash
docker-compose up -d

```

### Verifying Extensions

Once the database is running, you can connect and verify the extensions are active:

```sql
SELECT extname, extversion FROM pg_extension;
-- Expected output should include 'postgis' and 'vector'

```

## 🏗️ CI/CD Architecture

This project is maintained automatically via GitHub Actions:

1. **Dependabot** monitors Docker Hub for exact SHA digest updates to `postgres:18-bookworm`.
2. When a security patch or minor update (e.g., `18.x`) is released, Dependabot opens a PR.
3. **GitHub Actions** runs a dry-run build using Buildx to ensure extension compatibility.
4. Upon merge, the workflow tags the new image (`18`, `latest`, and `<git-sha>`) and pushes it to `ghcr.io`.

> **Note on Alpine:** We strictly use the Debian (`bookworm`) base image. Alpine (`musl`) is notorious for introducing floating-point geometry rounding errors in PostGIS, compatibility issues with pgvector C dependencies, and massive CI/CD bottlenecks since it lacks pre-compiled PGDG APT packages.

## ⚠️ Major Version Upgrades

This pipeline is pinned to PostgreSQL 18. If a new major version (e.g., PostgreSQL 19) is released, **this pipeline will not automatically upgrade**.

PostgreSQL data files are not binary-compatible across major versions. Major upgrades require manual intervention using `pg_upgrade` or a dump/restore strategy to safely migrate the existing `pgdata` volume.
