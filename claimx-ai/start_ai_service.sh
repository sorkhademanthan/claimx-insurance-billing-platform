#!/bin/bash

# Exit on error
set -e

echo "🤖 Initializing AI Service..."

# Ensure the setup script is executable
chmod +x apps/ai-service/setup_env.sh

# Check if venv exists; if not, run the setup script
if [ ! -d "apps/ai-service/venv" ]; then
    echo "⚠️  Virtual environment missing. Running setup..."
    ./apps/ai-service/setup_env.sh
fi

# Activate the environment and start the server
echo "🚀 Starting FastAPI Server..."
source apps/ai-service/venv/bin/activate
python apps/ai-service/main.py
