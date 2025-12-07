#!/bin/bash

# Exit on error
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to the ai-service directory
cd "$SCRIPT_DIR"

echo "🐍 Setting up Python Virtual Environment in $SCRIPT_DIR..."

# 1. Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment in 'venv'..."
    python3 -m venv venv
else
    echo "Virtual environment already exists."
fi

# 2. Activate and Install Dependencies
echo "📦 Installing dependencies from requirements.txt..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Setup complete!"
