# Auth API — Local Dev

This is a minimal NestJS-based Auth API for development purposes.

How to run:
1) Install dependencies at repo root:
   - npm install
   - or pnpm install

2) Start the application:
   - npx nx serve auth-api

3) Endpoints:
   - POST /auth/signup  -> body {email, password, name}
   - POST /auth/login   -> body {email, password}
   - The login returns {access_token, expires_in}.

Note:
- This implementation uses in-memory user storage for dev/testing. Replace with Postgres-backed UsersService in Phase 2. Use the infra seeds and Prisma/TypeORM in the next steps.
