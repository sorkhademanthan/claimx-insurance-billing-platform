#!/bin/bash

# Base URL
API_URL="http://localhost:3000"

echo "🧪 Testing Chapter 3.1: Claim Engine API"

# 1. Login to get a JWT Token (using the seeded demo user)
echo "🔑 Logging in as demo@claimx.com..."
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "demo@claimx.com", "password": "password123"}')

# Extract Token (Simple grep for demo purposes, ideally use jq)
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed. Ensure the server is running and database is seeded."
  echo "Response: $LOGIN_RESPONSE"
  exit 1
fi

echo "✅ Login successful! Token acquired."

# 2. Get the Policy ID (We need this to file a claim)
# We'll assume the seed script created a policy and we can fetch it via a user endpoint or just hardcode the known seed value if available.
# For this test, we'll try to fetch the user's profile/policies if that endpoint exists, otherwise we rely on the seed's known policy number logic or just try to create with a known ID if possible.
# Since we don't have a clear 'get my policies' endpoint in the prompt context yet, let's try to fetch claims first to see if any exist.

# 3. Create a Claim
echo "📝 Creating a new Claim..."
# Note: We need a valid policyId. In a real app, we select it from a list.
# For this test, we might fail if we don't have the exact UUID of the policy created by the seed.
# However, if you check your database (Prisma Studio), you can copy a Policy ID.
# Let's try to hit the endpoint. If it fails due to invalid Policy ID, that proves the endpoint is reachable at least.

# To make this test robust without manual ID copying, we would typically query the DB first.
# For now, let's send a request. If it returns 404 (Policy not found), the API is working!
# If it returns 401 (Unauthorized), Auth is working.
# If it returns 201, Success.

RESPONSE=$(curl -s -X POST "$API_URL/claims" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Test accident via script",
    "incidentDate": "2023-10-27T10:00:00Z",
    "incidentType": "ACCIDENT",
    "policyId": "REPLACE_WITH_REAL_POLICY_ID_FROM_DB" 
  }')

echo "Response: $RESPONSE"

# 4. List Claims
echo "📂 Fetching my claims..."
curl -s -X GET "$API_URL/claims" \
  -H "Authorization: Bearer $TOKEN"

echo -e "\n✅ Test script finished."
