# Phase 2 — User Authentication & Policy Lookup

Goal: Implement secure user authentication (JWT + RBAC) and a policy lookup API that allows users to search and retrieve their policies.

Objectives
- Auth service with JWT token issuance, RBAC and roles (user, adjuster, admin).
- Policy service/API that exposes policy search & retrieval.
- DB seeding for policies and sample accounts for testing.
- Frontend to display policy lookup UI and role-based access.

Deliverables
- Auth service scaffolding + endpoints: signup/login, profile, roles management.
- Policy service scaffolding + endpoints: GET /policies?userId=, GET /policies/{policyNo}
- DB seeder with 10 sample policies.
- Frontend form for policy lookup (basic).

Checklist
- [ ] Create Auth API (NestJS) via Nx generator.
- [ ] Create Policy API (NestJS) via Nx generator, or add endpoints inside claims service.
- [ ] Add DB migrations/seed for sample policies and accounts.
- [ ] Implement JWT middleware and RBAC guard.
- [ ] Add simple policy lookup UI in the web app.
- [ ] Add unit and integration tests for auth + policy lookup.

How to scaffold quickly
1) Generate Auth API:
- npx nx g @nx/nest:application auth-api --directory=apps --linter=eslint --unit-test-runner=jest

2) Generate Policy API (or reuse claims-api):
- npx nx g @nx/nest:application policy-api --directory=apps --linter=eslint --unit-test-runner=jest
- OR: Reuse existing apps/claim-service and add policy module.

3) Add shared libs:
- npx nx g @nx/js:library libs/auth-shared
- npx nx g @nx/js:library libs/policy-shared

Next steps: see chapters 2.1 and 2.2 for details.
