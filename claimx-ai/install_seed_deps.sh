#!/bin/bash

echo "📦 Installing dependencies for seeding..."

# Install ts-node to run the script
npm install ts-node --save-dev

# Install types for bcrypt and node to prevent TS errors
npm install @types/bcrypt @types/node --save-dev

echo "✅ Dependencies installed. You can now run: npx ts-node prisma/seed.ts"
