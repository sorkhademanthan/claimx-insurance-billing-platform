#!/bin/bash

echo "🛠️  Fixing Project Types..."

# 1. Generate Prisma Client (This creates the 'IncidentType' and 'Claim' types)
npx prisma generate

# 2. Push Schema to DB (This creates the tables in Postgres)
npx prisma db push

echo "✅ Fix complete. Please restart your VS Code or TypeScript server if errors persist."
