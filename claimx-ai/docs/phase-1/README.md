# Phase 1 — Ideation & Scaffolding

Goal: Establish the project's technical foundation and skeleton code.

Status: Workspace created (nx v22.1.3). Next actions below.

Chapters:
- [1.1 Understanding the Requirements](./chapter-1.1-understanding-requirements.md)
- [1.2 Architecture Blueprint](./chapter-1.2-architecture-blueprint.md)
- [1.3 Initial Setup](./chapter-1.3-initial-setup.md)

Progress:
- [x] NX workspace created (claimx-ai)
- [ ] Monorepo skeleton: apps & libs generated
- [ ] Dev infra (docker-compose) added
- [ ] Basic auth & claims APIs scaffolded

Next steps:
- Run infra:
  - ./infra/scripts/bootstrap.sh
- Generate apps (example commands):
  - pnpm nx g @nrwl/nest:application auth-api
  - pnpm nx g @nrwl/nest:application claims-api
  - pnpm nx g @nrwl/react:application web
- Add DB migrations & a seed script
- Add a minimal health check endpoint in auth-api and claims-api for readiness checks
