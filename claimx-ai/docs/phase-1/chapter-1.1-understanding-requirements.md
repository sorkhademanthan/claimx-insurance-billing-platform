# Chapter 1.1 — Understanding the Requirements

Purpose: Capture domain knowledge and success criteria before starting code.

1. The Claims Lifecycle (Happy Path)
- FNOL (First Notice of Loss): User reports incident via UI (or agent).
- Triage: Verify policy validity, premium status, and coverage limits.
- Assessment: AI summarizes incident, extracts key attributes, and ranks urgency.
- Fraud Check: ML model generates fraud probability.
- Settlement: Low risk & small amount => auto-approve. Otherwise, route to adjuster.

2. Actors
- Policyholder (web/mobile)
- Adjuster / Backoffice user (admin)
- System components: API Gateway, Auth Service, Claims Service, AI & OCR services, Fraud Service, Event Broker

3. Non-Functional Requirements (NFR)
- Resilience: Maintain claim submission even if fraud service or AI service is temporarily offline.
  - Approach: Queue claim events and process asynchronously; use circuit-breakers and retries; return optimistic response to user.
- Scalability: Support horizontal scaling and graceful degradation for spikes (10k claims/day).
  - Approach: Message broker for async processing; auto-scaled stateless services.
- Auditability: Immutable audit log for every action (submit, update, approve).
  - Approach: Write events to claim_events table + append-only logs.
- Security: RBAC, input sanitization, secret management, rate limiting.

4. Success Criteria & Acceptance
- Success sentence: “This project will be successful when the user can submit a claim and receive an automated classification and an initial fraud score within 5 minutes in 95% of transactions, while critical failures degrade gracefully without losing submissions.”
- Minimum viable version (MVP):
  - Submit claim + required docs, basic AI classifier summary, fraud score returned, claim stored.
- Metrics:
  - TAT: Median claim flow under 5 mins for simple claims.
  - Reliability: System accepts & persists 99% of claims even if downstream services are unavailable.

5. Edge Cases & Risks
- Duplicate claims: Deduplicate by time + user + incident descriptions; add idempotency on submission.
- Partial uploads: Support multi-part resumable uploads or transactional metadata creation prior to file object storage.
- Fraud service outage: Continue to persist claims with "fraud_check_pending" status and backfill when service resumes.

6. Action Items
- Validate the lifecycle using a short, mocked flow prior to full AI/ML integration.
- Document acceptance criteria in PR template and include regression tests.

---

## Troubleshooting: Generated Nx apps appear at repo root (no apps/ folder)

If Nx generators create apps at the repository root instead of /apps, fix quickly:

1) Verify installed plugins
- npx nx list
  - Confirm @nx/nest, @nx/react or @nrwl/* equivalents are installed.

2) Preferred solution — generate into the apps/ directory:
- npx nx g @nx/nest:application claim-service --directory=apps
- npx nx g @nx/react:application claim-dashboard --directory=apps --style=css

3) If apps already exist at the root, move them (recommended: use Nx move generator when available)
- Try Nx move generator:
  - npx nx g @nrwl/workspace:move claim-service apps/claim-service
  - or npx nx g @nx/workspace:move claim-service apps/claim-service
- If the move generator is not available, use manual steps:
  - mkdir -p apps
  - git mv claim-service apps/claim-service
  - git mv claim-service-e2e apps/claim-service-e2e
  - git mv claim-dashboard apps/claim-dashboard
  - Then update any per-project `project.json` or workspace config entries (`nx.json`/`workspace.json`) to set "root" and "sourceRoot" to `apps/<project>`.

4) Validate workspace and apps
- ls -la apps  # should show claim-service and claim-dashboard
- npx nx graph # should visualize projects under apps/
- npx nx show project @claimx-ai/claim-service  # verify root/sourceRoot paths
- npx nx serve claim-service
- npx nx serve claim-dashboard

5) If generators fail or plugins are missing
- Install plugin(s):
  - npm install --save-dev @nx/nest @nx/react
  - (or pnpm add -D @nx/nest @nx/react)
- If you see network errors, run:
  - npm cache clean --force
  - npm set registry https://registry.npmjs.org/
  - npm --network-timeout=100000 install

6) Notes & Best Practice
- Always use `--directory=apps` when creating new apps to keep the repo layout consistent.
- If you prefer absolute enforcement, update `nx.json` workspaceLayout to include:
  - "workspaceLayout": { "appsDir": "apps", "libsDir": "libs" }
  - This should make generator defaults place apps under /apps (confirm with generator doc).
- Add this small check in your PR checklist: "New apps are inside /apps, libs are inside /libs" to keep layout consistent.
