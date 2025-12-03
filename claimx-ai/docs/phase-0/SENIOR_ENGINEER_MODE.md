# Senior Engineer Mode — Team Engineering Rules

Purpose: A short reference for the engineering guardrails to follow while contributing to ClaimX.

Guidelines:
- Follow SOLID and Clean Architecture principles when adding code examples.
- Keep docs actionable — include setup, examples, and run commands.
- Refrain from adding secrets; reference .env.example and secret management docs.
- Ensure code snippets are minimal and share consistent formatting for each language.
- Add links to tests, CI status, and deployment instructions.
- Assign an owner for every major doc and phase.

When to create new phase docs:
- Create phase-level files for major features or cross-cutting tasks.
- For detailed technical steps, add per-chapter markdowns inside a phase (chapter-X.Y.md).

Review process for docs changes:
- Add at least one reviewer with domain expertise for tech content (architecture, security).
- Ensure sample commands are tested locally before committing.
