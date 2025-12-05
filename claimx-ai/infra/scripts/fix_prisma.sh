#!/bin/bash

# Exit on error
set -e

echo "🔧 Fixing Prisma Environment..."

# 1. Generate the Prisma Client (Creates the types like IncidentType)
echo "🔄 Generating Prisma Client..."
npx prisma generate

# 2. Push the schema to the DB (Ensures DB has the new tables/columns)
echo "🚀 Pushing schema to database..."
npx prisma db push

echo "✅ Prisma fixed! Your TypeScript errors regarding 'IncidentType' and missing properties should disappear."
