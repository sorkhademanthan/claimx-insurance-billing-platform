#!/bin/bash

echo "🤖 Testing AI Service Health..."

# Ping the health endpoint
RESPONSE=$(curl -s http://localhost:8000/health)

echo "Response: $RESPONSE"

if [[ "$RESPONSE" == *"healthy"* ]]; then
    echo "✅ AI Service is RUNNING and HEALTHY!"
else
    echo "❌ AI Service is NOT responding. Please check if it's running."
    echo "Try running: source apps/ai-service/venv/bin/activate && python apps/ai-service/main.py"
fi
