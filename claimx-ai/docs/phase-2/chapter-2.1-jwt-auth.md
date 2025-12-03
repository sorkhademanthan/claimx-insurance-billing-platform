# Chapter 2.1 — JWT Authentication Module

Goal: Implement JWT-based authentication in a dedicated NestJS Auth Service.

Core requirements
- Signup (POST /auth/signup): create user, hash password (bcrypt), assign role(s).
- Signin (POST /auth/login): verify credentials, return JWT with user id & roles.
- Profile (GET /auth/me): return user profile from the JWT token.

Design & Tech
- NestJS + Passport-JWT
- PostgreSQL (existing infra) for storing users and roles.
- bcrypt for password hashing
- Role-based access control (RBAC) via custom decorator + guard.

Database schema (minimal)
- users (id, email, hashed_password, name, role, created_at)
- roles (role_name: 'user'|'adjuster'|'admin')
- permissions (optional for complex RBAC)

Implementation Plan (one step at a time)
- Generate the auth-app:
  - npx nx g @nx/nest:application auth-api --directory=apps --linter=eslint --unit-test-runner=jest
- Add NestJS modules/services:
  - AuthModule: login/signup, jwt strategy
  - UsersModule: CRUD + findByEmail
  - Guards: JwtAuthGuard + RolesGuard
- Sample commands to implement features:
  - `pnpm nx generate @nx/nest:module users --project=auth-api`
  - `pnpm nx generate @nx/nest:controller users --project=auth-api`
  - `pnpm nx generate @nx/nest:service users --project=auth-api`
- JWT config:
  - Use environment variables: JWT_SECRET, JWT_EXPIRES_IN
  - Create provider for JwtModule.registerAsync (use ConfigService)

Minimal DTOs and endpoints (examples)
- POST /auth/signup
  - body: { email, password, name }
  - returns: { id, email, name, token }
- POST /auth/login
  - body: { email, password }
  - returns: { token, expiresIn }

Security & Best Practices
- Use strong hashing (bcrypt with >= 12 rounds).
- Store only hashed passwords.
- Add refresh tokens (optional for production).
- Add rate-limiting for login endpoint (prevent brute force).
- Ensure HTTPS in production and secure cookies if using them.

Testing
- Unit tests for AuthService (login, signup)
- Integration: sign up table THEN login flows
- E2E tests via `npx nx e2e auth-api-e2e`

Next: Chapter 2.2 covers policy lookup API details and db seeding.
