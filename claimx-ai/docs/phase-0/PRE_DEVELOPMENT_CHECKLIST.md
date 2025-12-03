# Pre-Development Checklist (Short Answers)

Purpose: A concise template to complete before starting any feature or phase.

1) Define the Purpose & Success Criteria
- What problem does this solve?
  - Short answer: e.g., "Reduce manual claim verification time for small motor claims."
- Who will use it?
  - Short answer: e.g., "Claims adjusters and retail policyholders on web/mobile."
- What does “done” look like?
  - Short answer: e.g., "UI + API + tests deployed to staging, and end-to-end flow validated."
- What is the MVP?
  - Short answer: e.g., "Web form + document upload + basic AI classifier output + storage."
- Success metric?
  - Short answer: e.g., "Average claim processing time reduced from 72h to <4h."
- One-sentence success statement:
  - “This project will be successful when average claim handling time drops below X and ≥80% of claims are touchless.”

2) Research & Benchmark Competitors
- What to capture:
  - Competitor | Strength | Weakness | Inspiration
- Example:
  - "FastClaim | Fast automation | Not customizable | Use their instant preview UX."

3) Feature Prioritization (MoSCoW)
- Must Have: Essential to MVP.
- Should Have: Important; can ship later.
- Could Have: Nice-to-have.
- Won’t Have: Out-of-scope this phase.
- Example:
  - Must: JWT Auth, policy lookup, claim form.
  - Should: Notifications, audit logging.
  - Could: Mobile PWA.
  - Won’t: In-depth ML explainability.

4) System Architecture Plan (1–2 bullets)
- Include: backend stacks, DB, message bus, storage, AI microservices.
- Quick example: "NestJS APIs, Postgres, Kafka, FastAPI for AI, Supabase for object storage."

5) Technical Specification (Essentials)
- Requirements: API SLA, error cases, non-functional reqs.
- Constraints: Legal/regulatory, data residency.
- Risks: Model drift, PII leaks.
- Perf Target: e.g., "API 90th p95 <= 300ms."

6) Design Workflow & UX (one-line each)
- User Input: What the user submits.
- Wait State: Loading + progress indicators.
- Output: Result display & next steps.
- Example: "User uploads receipt; show OCR progress; display extracted fields for confirmation."

7) Database & Data Flows (describe in 2 lines)
- Tables & relations (claims, users, policies, events).
- Index strategy: query performance goals and fields to index.
- Data sanitation: validate and sanitize on entry.

8) Coding Guidelines (short checklist)
- Linting, tests, naming conventions, DI.
- Example: "TypeScript strict, Jest unit tests > 80% coverage, ESLint rules enforced."

9) Security Checklist (minimum)
- Input validation & sanitization.
- RBAC and least privilege.
- Secure storage for secrets (no secrets-in-repo).
- Rate limiting and monitoring.

10) Deployment & CI/CD
- Hosts: Vercel (frontend), Render/Railway (backend), Supabase (storage).
- Pipeline: PR -> tests -> build -> staging -> manual/auto promote.
- Monitoring: Sentry/Datadog + Prometheus/Grafana.

11) Evaluation & Improvement (feedback loop)
- Weekly sprint review: what worked, what didn't.
- Metrics: Track TAT, false positives on fraud model, user satisfaction.

Bonus: README Before Starting
- Quick template:
  - Vision, Folder plan, Stack.
  - Target: "By end of sprint 1, the claim form and basic pipeline are complete."

Where to store finalized answers:
- Add to feature branch docs or PR description; merge to phase docs once validated.
