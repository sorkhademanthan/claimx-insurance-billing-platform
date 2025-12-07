#!/bin/bash

echo "🔄 Resetting Database State..."

# 1. Push Schema (Just in case)
npx prisma db push

# 2. Run the aggressive seed script
npx ts-node prisma/seed.ts

echo "✅ Reset Complete."
echo "👉 IMPORTANT: Log out of the frontend and log in again to get a new token!"
