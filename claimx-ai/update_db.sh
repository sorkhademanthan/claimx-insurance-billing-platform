#!/bin/bash

echo "🔄 Updating Database Schema..."

# 1. Push changes to Postgres
npx prisma db push

# 2. Regenerate the Client (so TypeScript knows about 'riskScore')
npx prisma generate

echo "✅ Database updated with AI fields!"
