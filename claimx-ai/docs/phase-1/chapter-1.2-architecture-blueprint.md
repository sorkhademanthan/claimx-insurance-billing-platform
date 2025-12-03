# Chapter 1.2 — Architecture Blueprint

Purpose: Codify the high-level architecture with events and integration points.

1. High-Level Components
- Frontend: React + Tailwind (UI + Admin)
- API Gateway / Backend: NestJS (REST & GraphQL)
- Auth Service: NestJS + PostgreSQL + JWT
- Claims Service: NestJS + PostgreSQL
- AI Analysis: FastAPI (LangChain / OpenAI / HF)
- Fraud Service: FastAPI (scikit-learn / logistic regression)
- OCR Service: FastAPI (Tesseract / Google Vision)
- Event Broker: Kafka / Redpanda
- Storage: Supabase Storage (or S3)
- Observability: OpenTelemetry + Prometheus + Grafana

2. Event Flow (Key topics)
- claim_submitted
- claim_analyzed
- fraud_score_generated
- decision_required
- claim_status_updated

3. Design Considerations & Patterns
- Event-driven: Decouple services and enable horizontal scaling.
- Idempotency: Use claim_id + event versioning to prevent reprocessing.
- Circuit Breakers & Retries: Use backoffs and DLQs for failed events.
- Observability: Pass trace headers across services using W3C Trace Context.
- Security: Validate JWT at API Gateway and never store tokens in logs.

4. Example Minimal DB schema
- users (id(pk), name, email, role, created_at)
- policies (id(pk), user_id, policy_no, start_date, end_date, status)
- claims (id(pk), policy_id, user_id, amount, status, created_at, updated_at)
- claim_documents (id(pk), claim_id, storage_key, metadata)
- claim_events (id(pk), claim_id, event_type, payload jsonb, created_at)

5. Example Event Payloads
- claim_submitted
  - { claimId, policyNumber, userId, incidentDate, details, documents: [{ name, url }] }
- fraud_score_generated
  - { claimId, fraudScore, modelVersion, reasons: [] }

6. Resilience & Scaling Examples
- If AI service fails:
  - Claims Service should return "submitted" to user with metadata "analysis_pending"
  - Background consumer attempts analysis later and publishes result.
- If DB writes fail:
  - Make writes idempotent and retry with exponential backoff.
- Use partitioned Kafka topics by claimId hash for better consumer scaling.

7. Security & Compliance
- Ensure PII encrypted at rest for DB/storage.
- Add audit trail of user actions in claim_events.

8. Deliverables for Phase 1
- Architecture diagram (add to docs/phase-0/diagrams).
- Event schema definitions (.avsc or JSON Schema).
- ADR for decision to use Kafka + Supabase.
