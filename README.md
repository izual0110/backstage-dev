# Backstage development portal

A test Backstage application with local PostgreSQL and GitLab instances. The
frontend and backend source code lives in `packages/`, while `compose.yaml`
defines the local development infrastructure.

## Included components

- Backstage frontend and backend with guest authentication for local development;
- PostgreSQL storage for Backstage and a separate PostgreSQL database for GitLab;
- GitLab Community Edition available at `http://localhost:8080`;
- a GitLab catalog provider that searches for `catalog-info.yaml` every 30 minutes;
- a **Node.js service in GitLab** software template that creates a private project
  and immediately registers it in the catalog.

## Requirements

- Node.js 22 or 24;
- Docker with Compose v2;
- at least 6 GB of available memory for GitLab.

## Getting started

1. Create the local environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the infrastructure. The initial GitLab startup usually takes several
   minutes:

   ```bash
   docker compose up -d
   docker compose ps
   ```

3. Create an idempotent personal access token for Backstage. The script waits
   until GitLab reports a `healthy` status and assigns the root user a token with
   the `api` scope:

   ```bash
   ./scripts/bootstrap-gitlab.sh
   ```

4. Export the environment variables, install dependencies, and start Backstage:

   ```bash
   set -a
   source .env
   set +a
   yarn install
   yarn start
   ```

5. Open Backstage at `http://localhost:3000` and sign in as a guest. GitLab is
   available at `http://localhost:8080` (username `root` and the password from
   `GITLAB_ROOT_PASSWORD`).

## Creating a project from the template

1. Open **Create** in Backstage.
2. Select **Node.js service in GitLab**, then click **Choose**.
3. Enter the project name and description.
4. Under Repository Location, enter `root` as the owner and provide the new
   repository name.
5. Click **Create**. Backstage renders the template, creates a private GitLab
   project, and registers its `catalog-info.yaml` in the catalog.

Publishing uses the server-side `GITLAB_TOKEN`; users do not need to provide
their own token in the form.

## Useful commands

```bash
# Follow GitLab logs
docker compose logs -f gitlab

# Run application checks
yarn tsc
yarn lint:all
yarn test

# Test PostgreSQL initialization in isolated containers
yarn test:integration

# Stop services
docker compose down

# Remove all development data
docker compose down -v
```

PostgreSQL and GitLab data is stored in named Docker volumes. The initialization
SQL file runs only when the `postgres-data` volume is first created.
