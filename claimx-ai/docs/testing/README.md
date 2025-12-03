# Testing — Strategy and Templates

Purpose: Testing guidelines and templates for unit, integration, e2e, and performance.

Strategy Overview:
- Unit tests: Jest for TypeScript; PyTest for Python microservices.
- Integration tests: docker-compose or testcontainers for DB/message broker.
- E2E: Cypress/Playwright for UI; Postman/Newman for API flows.
- Performance: k6 for throughput and latency testing.

Sample checks in CI:
- Run linting + type check
- Run unit tests with coverage
- Run integration tests (backend + DB)
- Run UI E2E tests (smoke)
- Run docs checks: markdownlint, markdown-link-check

Templates:
- Add test-plan.md to describe test coverage and acceptance criteria.
- Add smoke-test checklist with primary API endpoints.
