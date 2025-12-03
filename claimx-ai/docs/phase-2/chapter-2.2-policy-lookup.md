# Chapter 2.2 — Policy Lookup Feature

Goal: Provide secure endpoints for users to lookup their policies, accessible from the frontend after authentication.

API Endpoints (Auth-protected)
- GET /policies?userId={id}
  - Returns: list of policies for the specified user
- GET /policies/{policyNo}
  - Returns: policy details for the given policy number (only if user has access)
- GET /policies/search?q={query}
  - Optional: search by policyNo, insured name, vehicle VIN, etc.

DB schema (sample)
- policies (id, user_id, policy_no, type, start_date, end_date, status, pmnt_status, premium, created_at)
- claims (id, policy_id, claim_no, status, amount, created_at)

Seeding (sample SQL is in infra/seeds/policies.seed.sql)
- Create sample users and policies. Consider adding 10 policies with different types and statuses for testing.

Frontend integration
- UI: policy lookup form with fields (policyNo or search).
- Use JWT from login, attach Authorization: Bearer <token>.
- Validate user role (only owners can view their policies).
- Add a policy detail view for claims and actions.

Authorization constraints
- Only the policy owner (userId) or admin can view/edit a policy.
- Implement check middleware to confirm user id in token matches userId in queried policy or has admin role.

Acceptance Test (End-to-End)
- Login -> get token -> call GET /policies?userId=<token.userId> -> see list of policies.
- Login -> call GET /policies/{policyNo} (not owned) -> ensure 403.
- Add basic UI tests using E2E (Playwright/Cypress) for the policy lookup flow.

Next Steps
- Implement endpoints in Policy API or Claims API.
- Wire tests and ensure RBAC checks pass.
