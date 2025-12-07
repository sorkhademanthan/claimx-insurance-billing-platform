#!/bin/bash

echo "🔄 Restarting AI Service..."

# 1. Find and kill the process running on port 8000
PID=$(lsof -ti:8000)
if [ -n "$PID" ]; then
  echo "Killing old process (PID: $PID)..."
  kill -9 $PID
else
  echo "No existing process found on port 8000."
fi

# 2. Start the service again
./start_ai_service.sh
