#!/bin/bash

echo "🚀 Setting up Phase 2 environment..."

# 1. Install required dependencies for seeding
echo "📦 Installing dependencies..."
npm install ts-node @types/bcrypt @types/node --save-dev

# 2. Generate Prisma Client (Updates types based on schema.prisma)
echo "🔄 Generating Prisma Client..."
npx prisma generate

# 3. Push schema to the database (Ensures DB structure matches schema)
echo "fw Pushing schema to database..."
npx prisma db push

# 4. Run the seed script
echo "🌱 Seeding database..."
npx ts-node prisma/seed.ts

echo "✅ Setup complete!"
