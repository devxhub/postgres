# We target the PostgreSQL 18 Bookworm base.
# Pinning to a sha256 digest allows Dependabot to track exact upstream releases.
FROM postgres:18-bookworm@sha256:882236b897e39051d2368c5ccc6cda944904723506b2dfc97f2a8f5bc9afa382

LABEL maintainer="Devxhub Limited" \
      description="PostgreSQL 18 LTS with PostGIS and pgvector"

# Install PostGIS and pgvector via the official PGDG repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      postgresql-18-postgis-3 \
      postgresql-18-postgis-3-scripts \
      postgresql-18-pgvector \
    && rm -rf /var/lib/apt/lists/*

# Automatically enable extensions for new databases upon first boot
COPY ./init-extensions.sql /docker-entrypoint-initdb.d/
