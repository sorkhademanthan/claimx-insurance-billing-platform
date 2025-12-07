#!/bin/bash

echo "🛠️  Fixing Database Schema..."

# 1. Push the schema changes to Postgres (Adds riskScore, isFlagged, etc.)
npx prisma db push

# 2. Regenerate the Prisma Client (Updates the TypeScript types)
npx prisma generate

echo "✅ Database schema is now in sync!"
echo "👉 Please restart your backend server (./start_dev.sh) for changes to take effect."
