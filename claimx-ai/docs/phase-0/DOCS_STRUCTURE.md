# Documentation Structure

This file explains the structure and best practices for the docs folder:

- docs/README.md — Index for the docs.
- docs/PROJECT_OVERVIEW.md — High-level project description and roadmap (already created).
- docs/phase-X/README.md — Per-phase summary with chapters, checklist, and owner.
- docs/testing/README.md — Testing strategy for docs + code.

Best practices:
- Keep README concise; create per-phase chapater files when the content grows (e.g., docs/phase-4/chapter-4-1-genai.md).
- Add diagrams to docs/phase-0/diagrams.
- Avoid secrets and credentials in the docs.
- Use branch-specific docs only if tied to a feature; merge into phase docs when finalized.
- Add metadata badges (lint/test) to docs/README when CI is set up.

Recommended CI checks:
- markdownlint
- markdown-link-check
- spellcheck
