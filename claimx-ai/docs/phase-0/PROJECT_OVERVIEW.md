# ClaimX AI — Project Overview

ClaimX AI is an enterprise-grade, event-driven insurance claim processing platform to automate the claims lifecycle using Gen-AI, microservices, and ML-driven fraud detection. This document captures the roadmap, architecture, tech stack, and quick-start guidance for contributors.

## Vision
- Reduce claim processing time from days to minutes using a "Touchless Claims" approach.
- Combine OCR, Gen-AI classification, and ML fraud scoring for automated decisioning.
- Designed for scale and maintainability via microservices and event-driven orchestration.

## Key Capabilities
- User authentication & RBAC
- Policy lookup and claim submission UI
- Document OCR and data extraction
- AI-driven claim classification and summarization
- ML-based fraud scoring
- Event-driven microservices (Kafka/Redpanda)
- Observability with OpenTelemetry
- Cloud-ready deployment & CI/CD

## Project Roadmap (Phases)
1. Ideation & Scaffolding
2. Authentication & Policy Lookup
3. Claim Submission & Storage
4. AI Classification & ML Fraud Prediction
5. Event-Driven Microservices & Observability
6. Document OCR Integration
7. Frontend Dashboards & Role-Based UX
8. Deployment, Documentation, and Interview Prep

Each phase is broken down into chapters outlining tasks, code highlights, and sample integrations. See the `docs/` folder for phase-specific READMEs as they are added.

## High-Level Architecture
- Frontend: React + Tailwind (SPA for users + admin dashboard)
- API Gateway / Backend: Node.js (NestJS)
- Microservices:
  - Auth Service (NestJS + PostgreSQL)
  - Claims Service (NestJS + PostgreSQL + Supabase Storage)
  - AI Analysis Service (Python FastAPI: GenAI classification)
  - ML Fraud Service (Python FastAPI: fraud model)
  - OCR Service (Python FastAPI: Google Vision / Tesseract)
- Event Streaming: Kafka / Redpanda (claim_submitted, claim_analyzed, fraud_score_generated, decision_required)
- Database: PostgreSQL (primary), Supabase for object storage
- Observability: OpenTelemetry / Prometheus / Grafana
- CI/CD: GitHub Actions + Docker images

## Tech Stack Summary
- Frontend: React, Tailwind CSS
- Backend: Node.js, NestJS, TypeScript
- Python microservices: FastAPI for AI/ML/OCR
- Database: PostgreSQL
- Storage: Supabase Storage (or S3)
- Messaging: Kafka / Redpanda
- Dev workflow: Monorepo (Nx/TurboRepo), Docker, GitHub Actions

## Quick Start (Local Dev)
Prerequisites:
- Node.js (>=16), npm or pnpm
- Docker & docker-compose
- PostgreSQL (local or Docker)
- Kafka / Redpanda (docker-compose for dev)
- Python (for AI/ML microservices)

Suggested local steps:
1. Clone:
   - git clone <repo-url>
   - cd ClaimX
2. Install dependencies:
   - npm install
3. Start DB & Infrastructure (example using docker-compose):
   - docker-compose -f docker/docker-compose.dev.yml up -d
4. Start backend services (example):
   - pnpm nx serve auth-api
   - pnpm nx serve claims-api
5. Start Python AI/ML services:
   - cd services/ai && uvicorn main:app --reload
6. Start frontend:
   - pnpm nx serve web
7. Visit UI and test flows (signup, policy lookup, submit claim)

Note: Replace commands with actual package manager scripts once workspace is scaffolded.

## Folder Structure (suggested)
- apps/           -> frontend & backend deployable apps
- libs/           -> shared utilities and DTOs
- services/       -> python microservices (ai, ocr, fraud)
- infra/          -> docker, kafka, postgres, terraform
- docs/           -> project documentation (this folder)

## Contribution Guide
- Branching model: feature/*, fix/*, chore/*
- Add tests for all features (unit + integration)
- Document new endpoints in OpenAPI/Postman collection
- Create PRs with clear descriptions and linking issues

## Observability & Monitoring
- Integrate OpenTelemetry for trace context across services
- Centralized logs with ELK or Grafana Loki for debugging
- Prometheus metrics for throughput and latency

## Security & Compliance
- Ensure RBAC and secure JWT tokens
- Sanitize user input and uploaded documents
- Encrypt sensitive data at rest (Supabase or DB)
- Add rate limits and guardrails on AI/ML endpoints

## Next Steps & Priorities
- Complete monorepo scaffolding with sample apps & libraries
- Implement auth and policy lookup APIs
- Build React claim submission UI & file upload
- Implement Python OCR & ML services
- Add Kafka-based event orchestration
- Prepare CI/CD and cloud deployment scripts
- Create interview-friendly demo script & metrics

## Interview & Demo Checklist
- 2–3 minute demo flow (submit claim -> AI analysis -> fraud score -> decision)
- Diagrams: sequence, stack, and dataflow
- Key metrics: latency, throughput, predicted vs actual performance
- Talking points: scaling, fault-tolerance, observability, security

## Where to find more docs
- Add per-phase docs in this `docs/` folder:
  - docs/phase-1-ideation.md
  - docs/phase-2-auth-policy.md
  - docs/phase-3-claims.md
  - ...
- Expand README for each microservice to include env vars and run steps.

---

This document is intentionally concise and focused; expand per service and phase with deeper guides, code samples, and diagrams as the project evolves.
