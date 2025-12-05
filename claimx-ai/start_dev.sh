#!/bin/bash

echo "🚀 Starting auth-api (Nx Workspace)..."

# In an Nx workspace, we use 'nx serve' instead of 'npm run start:dev'
npx nx serve auth-api
