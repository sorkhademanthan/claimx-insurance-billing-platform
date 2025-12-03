# Chapter 1.3 — Initial Setup (Sequential Command Flow)

Purpose: Create the repository structure and local dev environment.

Status: NX workspace 'claimx-ai' has been created successfully (v22.1.3). Continue with the scaffold by creating apps and dev infra.

Quick one-by-one commands (run, verify, then continue):

1) Confirm you’re in workspace root:
- pwd && ls -la && cat nx.json

2) Check Docker:
- docker info || echo "Docker not running — start Docker Desktop / Docker Engine"

3) Start dev infra (only if Docker is running):
- chmod +x infra/scripts/bootstrap.sh && ./infra/scripts/bootstrap.sh

4) Check current apps location:
- ls -la apps || (ls -la | grep -E 'claim-service|claim-dashboard' || true)

5) Move existing root apps to apps/:
- chmod +x infra/scripts/move-apps-to-apps.sh && ./infra/scripts/move-apps-to-apps.sh claim-service claim-dashboard

6) If apps missing, generate backend:
- npx nx g @nx/nest:application claim-service --directory=apps --linter=eslint --unit-test-runner=jest

7) Generate frontend if missing:
- npx nx g @nx/react:application claim-dashboard --directory=apps --style=css --routing=true

8) Verify generated projects:
- ls -la apps && npx nx show project @claimx-ai/claim-service && npx nx show project @claimx-ai/claim-dashboard

9) Add a simple health controller to backend:
- npx nx g @nx/nest:controller health --project=claim-service

10) Serve backend & check health:
- npx nx serve claim-service
- curl http://localhost:3333/health

11) Serve frontend & check UIs:
- npx nx serve claim-dashboard
- open http://localhost:4200 (or visit the serve output port)

12) If DB missing:
- psql -h localhost -U claimx -d claimx_dev -c '\dt' || echo "Start DB or set DATABASE_URL"

---

This completes Phase 1 Chapter 1.3. If you want, I can now:
- Add a small health controller stub for the claim-service (NestJS) and update its README.
- Add a Prisma schema and a seed script for quick DB setup.
- Add CI job skeleton to enforce workspace layout and docs checks.

Which of those should I do next? (Pick one, I’ll implement it.)
  - If either fails, Docker is not running or not installed.
- Start Docker Desktop (macOS/Windows) or install Docker Engine (Linux). For macOS:
  - Open Docker Desktop and ensure "Docker is running" (or use `open -a Docker`).
- Temporary alternatives:
  - Use a local Postgres server (brew):
    - brew install postgresql
    - brew services start postgresql
    - psql -U <your-user> -h localhost -d claimx_dev
  - Use a cloud DB (Supabase, Railway) by setting DATABASE_URL in .env and skipping the docker-compose step for DB.
- After Docker is up, re-run:
  - chmod +x infra/scripts/bootstrap.sh && ./infra/scripts/bootstrap.sh

8. Generating apps (correct generator usage & folder)
- Ensure workspaceLayout is set in nx.json so generators default to apps/ (already configured).
- Recommended commands:
  - npx nx g @nx/nest:application claim-service --directory=apps --linter=eslint --unit-test-runner=jest
  - npx nx g @nx/react:application claim-dashboard --directory=apps --style=css --routing=true
- If you accidentally generated apps in the workspace root, move them:
  - Use Nx workspace move if available:
    - npx nx g @nrwl/workspace:move claim-service apps/claim-service
  - Or use the helper:
    - ./infra/scripts/move-apps-to-apps.sh claim-service claim-dashboard
  - Validate: ls -la apps

3. If apps already exist at the root, move them (recommended: use Nx move generator when available)
- Preferred (Nx move) for projects configured in the workspace:
  - npx nx g @nrwl/workspace:move --projectName=claim-service --destination=apps/claim-service
  - OR:
  - npx nx g @nx/workspace:move --projectName=claim-service --destination=apps/claim-service

- If you receive an Nx error like "Cannot find configuration for 'claim-service'", the workspace project name may be different from the folder name (e.g., '@claimx-ai/claim-service'). Use:
  - npx nx show project @claimx-ai/claim-service
  - If the project is present in the workspace, use the exact 'projectName' when calling the move generator.

- If the Nx generator is unavailable or fails (e.g., project not in workspace), fallback to the updated helper script:
  - chmod +x infra/scripts/move-apps-to-apps.sh
  - ./infra/scripts/move-apps-to-apps.sh claim-service claim-dashboard

- What the helper script does:
  - It attempts to run Nx's move generator with the correct flags.
  - If Nx move is not possible, it performs a safe fallback:
    - If files are tracked by Git: git mv <src> apps/<src> and moves e2e directories if present.
    - If files are untracked: regular mv + git add and prints guidance to update workspace.json or project.json.
  - It also attempts to update workspace.json project 'root' values if jq is installed, and prints instructions for manual fixes if not.

- Manual fallback steps:
  - If the helper script still doesn't update workspace.json, update the root/sourceRoot entries in:
    - workspace.json (root/editor-managed)
    - or the per-project project.json file (which is generally under the project's folder)
  - After moving, validate:
    - npx nx show project <projectName>
    - npx nx graph

9. Minimal health endpoint and smoke-check
- Backend (Nest):
  - Generate a controller if not present:
    - npx nx g @nx/nest:controller health --project=claim-service
  - Add a GET /health handler returning: { status: 'ok' }
- Frontend:
  - The React app created with the Nx generator includes a dev server on the specified port.
- Verify services:
  - npx nx serve claim-service
    - curl http://localhost:3333/health -> returns OK
  - npx nx serve claim-dashboard
    - open http://localhost:4200 or 5173 (default Vite port) depending on generator output.

10. DB migrations, seed & environment
- Choose a migration tool (Prisma recommended for TypeScript/NestJS).
  - pnpm add -D prisma @prisma/client
  - pnpx prisma init
  - Add schema and simple seed script (users, policies, sample claims).
- Environment:
  - Copy and edit .env.example -> .env
  - Ensure DATABASE_URL points to a running Postgres instance (local or remote).

11. Local dev checklist (complete these to finish Phase 1)
- [ ] Docker or local DB running (Postgres accessible)
- [ ] infra/scripts/bootstrap.sh executed successfully
- [ ] apps/ contains claim-service and claim-dashboard
- [ ] Both apps serve and respond to health checks
- [ ] A shared lib exists (shared-types) and imports build successfully
- [ ] Migrations applied and seed data inserted
- [ ] Basic unit tests exist for auth and claim endpoints (skeletons are OK)
- [ ] README updated and PR template updated to reference docs

12. Troubleshooting quick commands
- Verify Nx workspace:
  - npx nx list
  - npx nx graph
- Fix generators / plugins:
  - npm install --save-dev @nx/nest @nx/react
  - npx nx reset
- Check moving apps into apps/:
  - ./infra/scripts/move-apps-to-apps.sh claim-service claim-dashboard
- Validate app health:
  - curl http://localhost:3333/health
  - curl http://localhost:4200

13. Next steps (after local dev is stable)
- Create a basic CI job to:
  - Install dependencies
  - Run lint and tests
  - Validate docs with markdownlint
- Add example migrations and a seed script to the repository for reproducible local development.

---

This completes Phase 1 Chapter 1.3. If you want, I can now:
- Add a small health controller stub for the claim-service (NestJS) and update its README.
- Add a Prisma schema and a seed script for quick DB setup.
- Add CI job skeleton to enforce workspace layout and docs checks.

Which of those should I do next? (Pick one, I’ll implement it.)

7. Kafka & Redpanda
- We've replaced Redpanda with Confluent Kafka + Zookeeper (public images) in the dev compose because the Redpanda image may require authentication.
- If you prefer Redpanda, update infra/docker/docker-compose.dev.yml to use a Redpanda image you can access, and run `docker login` if necessary. Otherwise, Kafka is a widely accessible alternative.

8. Running the infra with Kafka and Zookeeper
- Start infra:
  - chmod +x infra/scripts/bootstrap.sh && ./infra/scripts/bootstrap.sh
- Kafka port is set using KAFKA_HOST_PORT; if 9092 is blocked, start with:
  - KAFKA_HOST_PORT=9093 ./infra/scripts/bootstrap.sh
- Skip broker if you just want Postgres & MinIO:
  - docker compose -f infra/docker/docker-compose.dev.yml up -d postgres minio pgadmin

9. Diagnosing image or port issues
- If `docker compose` fails with pull access errors, either:
  - docker login (if you own the image)
  - or modify `infra/docker/docker-compose.dev.yml` to a public image
- If ports are in use:
  - Use POSTGRES_HOST_PORT, KAFKA_HOST_PORT, MINIO_HOST_PORT or stop existing process/container holding the port.

Post-move verification & commit
- After moving the apps to `/apps`, verify and commit changes:
  - git status
  - git add -A
  - git commit -m "chore: move apps into apps/ directory and update workspace"
- Validate workspace and project roots:
  - npx nx show project @claimx-ai/claim-service || npx nx show project claim-service
  - npx nx show project @claimx-ai/claim-dashboard || npx nx show project claim-dashboard
- Visualize:
  - npx nx graph
- Run a quick smoke test:
  - npx nx serve claim-service  # wait for server: curl http://localhost:3333/health
  - npx nx serve claim-dashboard  # open reported port in a browser

Notes:
- If any project still points to old roots, edit `workspace.json` or the project's `project.json` `root`/`sourceRoot` fields to the correct `apps/<project>` path and re-run `npx nx show project <project>`.
- If the Nx generator indicates a different project name (prefixed with package name), use the exact project name when using `npx nx show project`.

Quick 5432 fix (one-at-a-time commands)
1) Check Docker containers using 5432:
- docker ps --filter "publish=5432" --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Ports}}"

2) If container shown, stop & remove it:
- docker stop <container-id> && docker rm <container-id>

3) If no container shown, check host process:
- lsof -i :5432 -sTCP:LISTEN -n -P

4) Stop local Postgres (macOS / Linux):
- macOS: brew services stop postgresql
- Linux (systemd): sudo systemctl stop postgresql

5) Or run bootstrap on alternate host port:
- POSTGRES_HOST_PORT=5433 ./infra/scripts/bootstrap.sh

6) Run the infra:
- chmod +x infra/scripts/bootstrap.sh && ./infra/scripts/bootstrap.sh

7) Verify infra:
- docker compose -f infra/docker/docker-compose.dev.yml ps
- psql -h localhost -p ${POSTGRES_HOST_PORT:-5432} -U claimx -d claimx_dev -c '\dt'

DB Credentials & Access (Quick commands)

- Default credentials:
  - POSTGRES_USER: claimx
  - POSTGRES_PASSWORD: claimx_pass
  - (These are examples — always check .env or container env for your workstation.)

- How to find the actual password used by your running Postgres container:
 1) Find the Postgres container:
    - docker ps --filter "ancestor=postgres:15" --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Ports}}"
    - Or: docker ps --filter "ancestor=postgres" --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Ports}}"

 2) Read the container's environment variables:
    - container_id=$(docker ps -q -f "ancestor=postgres")
    - docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' $container_id | grep -E '^POSTGRES_(USER|PASSWORD)='

 3) Connect from host (no prompt) using PGPASSWORD:
    - export PGPASSWORD=$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' $container_id | grep '^POSTGRES_PASSWORD=' | cut -d'=' -f2)
    - psql -h localhost -p ${POSTGRES_HOST_PORT:-5432} -U ${POSTGRES_USER:-claimx} -d claimx_dev -c '\dt'

- Alternative: Connect via the container to avoid host password issues:
  - docker compose -f infra/docker/docker-compose.dev.yml exec postgres psql -U postgres -d claimx_dev -c '\dt'
  - Or use the supplied helper to run queries:
    - chmod +x infra/scripts/db-psql.sh
    - ./infra/scripts/db-psql.sh '\dt'
    - Or to run a SQL query:
      - ./infra/scripts/db-psql.sh "SELECT count(*) FROM some_table;"

- Resetting the password (if needed):
 1) Change the POSTGRES_PASSWORD in your .env or docker-compose file (or use the interactive ALTER USER).
 2) If the DB is ephemeral (no persisted data), you can recreate the container:
    - docker compose -f infra/docker/docker-compose.dev.yml down -v
    - docker compose -f infra/docker/docker-compose.dev.yml up -d
 3) If DB has persisted data and you only want to change the user password:
    - docker compose -f infra/docker/docker-compose.dev.yml exec postgres psql -U postgres
    - In psql: ALTER USER claimx WITH PASSWORD 'new_password';
    - Exit and then use the new password from the .env or container env to connect.

Important notes:
- Avoid checking secrets into git. Keep .env in .gitignore; use .env.example for defaults.
- If your local DB is managed by a system package (e.g., Homebrew), you may want to stop that local DB or use an alternate POSTGRES_HOST_PORT to avoid collisions.

GitHub not showing folder contents? (Nested Git repo / submodule issue)
- Cause: If a folder contains its own .git, Git interprets it as a submodule or an embedded repo. The root repo will not embed that nested repo’s contents; instead it will record a submodule pointer.
- Check:
  - ls -la claimx-ai/.git
- Quick Fix — Make everything a single monorepo (recommended):
  1) Remove nested repo metadata
     - rm -rf claimx-ai/.git
  2) Stage & commit to root repo and push
     - git add claimx-ai
     - git commit -m "chore: flatten claimx-ai into root monorepo"
     - git push origin main
- Quick Fix — Keep claimx-ai as a separate repo (submodule)
  1) Create a remote repo for claimx-ai on GitHub (e.g., git@github.com:<user>/claimx-ai.git)
  2) Inside claimx-ai:
     - cd claimx-ai
     - git remote add origin git@github.com:<user>/claimx-ai.git
     - git add -A && git commit -m "initial commit"
     - git push -u origin main
  3) Add it as a submodule in the root repo:
     - cd ..
     - git submodule add git@github.com:<user>/claimx-ai.git claimx-ai
     - git add .gitmodules claimx-ai
     - git commit -m "Add claimx-ai as submodule"
     - git push origin main
- If you previously ran `git add claimx-ai` and saw hints about embedded repos, remove the pointer before converting:
  - git rm --cached claimx-ai
  - rm -rf .git/modules/claimx-ai
  - Then apply the desired fix above.

Note:
- After converting to a monorepo, update any per-project configs that may reference old relative paths (.e.g, tsconfig paths). Re-run `npx nx` sync and commit any auto-changes.
