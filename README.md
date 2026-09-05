# Backstage development portal

A sample Backstage application with local PostgreSQL and GitLab instances. The
frontend and backend source code is located in `packages/` at the repository
root, while the development infrastructure is defined in `compose.yaml`.

## What's included

- A Backstage frontend and backend with guest authentication for local
  development;
- PostgreSQL as the Backstage data store and a separate PostgreSQL instance for
  GitLab;
- GitLab Community Edition at `http://localhost:8080`;
- A GitLab catalog provider that searches for `catalog-info.yaml` every 30
  minutes;
- The **Node.js service in GitLab** software template, which creates a private
  project and immediately registers it in the catalog.

## Requirements

- Node.js 22 or 24;
- Docker with Compose v2;
- At least 6 GB of available memory for GitLab.

## First run

1. Create the local environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the infrastructure. GitLab usually takes several minutes to start for
   the first time:

   ```bash
   docker compose up -d
   docker compose ps
   ```

3. Create an idempotent personal access token for Backstage. The script waits
   until GitLab reports a `healthy` status and creates a token with the `api`
   scope for the GitLab root user:

   ```bash
   ./scripts/bootstrap-gitlab.sh
   ```

4. Export the environment variables, install the dependencies, and start
   Backstage:

   ```bash
   set -a
   source .env
   set +a
   yarn install
   yarn start
   ```

5. Open Backstage at `http://localhost:3000` and sign in as a guest. GitLab is
   available at `http://localhost:8080` (username: `root`; password: the value
   of `GITLAB_ROOT_PASSWORD`).

## Creating a project from the UI

1. Open **Create** in Backstage.
2. Select **Node.js service in GitLab**, then click **Choose**.
3. Enter a name and description.
4. Under Repository Location, set the owner to `root` and enter the name of the
   new repository.
5. Click **Create**. Backstage renders the template, creates a private GitLab
   project, and registers its `catalog-info.yaml` in the catalog.

Publishing uses the server-side `GITLAB_TOKEN`; users do not need to provide
their own token in the form.

## Useful commands

```bash
# Follow GitLab logs
docker compose logs -f gitlab

# Check the application
yarn tsc
yarn lint:all
yarn test

# Stop the services
docker compose down

# Delete all development data
docker compose down -v
```

PostgreSQL and GitLab data is persisted in named Docker volumes. The SQL
initialization file runs only when the `postgres-data` volume is first created.
