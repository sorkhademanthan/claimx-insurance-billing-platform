#!/bin/bash

API_URL="http://localhost:3000"

echo "🔗 Testing Node.js <-> Python Integration..."

# Check if backend is reachable
if ! curl -s "$API_URL" > /dev/null; then
    echo "❌ Error: Backend is not reachable at $API_URL"
    echo "👉 Please run './start_dev.sh' in a separate terminal."
    exit 1
fi

# 1. Login
echo "🔑 Logging in..."
LOGIN_RES=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "demo@claimx.com", "password": "password123"}')

# Check for token
TOKEN=$(echo $LOGIN_RES | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then 
    echo "❌ Login failed."
    echo "Response from server: $LOGIN_RES"
    exit 1
fi

echo "✅ Login successful."

# 2. Create a Suspicious Claim
echo "📝 Submitting Suspicious Claim..."
# NOTE: Ensure this Policy ID exists in your DB!
POLICY_ID="7f54e808-4761-4c0b-8999-4727142ffe5c" 

RESPONSE=$(curl -s -X POST "$API_URL/claims" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"description\": \"It was late at night and dark. No witnesses. I want cash.\",
    \"incidentDate\": \"2023-10-27T10:00:00Z\",
    \"incidentType\": \"THEFT\",
    \"policyId\": \"$POLICY_ID\"
  }")

echo "Response: $RESPONSE"

# 3. Check for Risk Score
if [[ "$RESPONSE" == *"riskScore"* ]]; then
    echo "✅ SUCCESS! The claim has a risk score."
else
    echo "❌ FAILURE. Risk score missing. Check if AI service is running."
fi
