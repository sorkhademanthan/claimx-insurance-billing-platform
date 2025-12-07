#!/bin/bash

# Exit on error
set -e

echo "📦 Installing Python dependencies for AI Service..."

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "⚠️  Virtual environment not found. Creating it first..."
    python3 -m venv venv
fi

# Activate venv and install
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Dependencies installed: FastAPI, Uvicorn, Pydantic."
echo "To run the server: source venv/bin/activate && python main.py"
