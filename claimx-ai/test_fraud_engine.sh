#!/bin/bash

echo "🕵️ Testing Fraud Detection Engine..."

# 1. Test a SAFE claim
echo -e "\n1️⃣  Sending SAFE claim..."
curl -X POST "http://localhost:8000/analyze" \
     -H "Content-Type: application/json" \
     -d '{
           "description": "I was driving on the highway and a deer jumped out. I hit the brakes but still made contact.",
           "incidentType": "ACCIDENT",
           "amount": 2500
         }' | python3 -m json.tool

# 2. Test a SUSPICIOUS claim (Keywords: "cash", "no witnesses")
echo -e "\n2️⃣  Sending SUSPICIOUS claim..."
curl -X POST "http://localhost:8000/analyze" \
     -H "Content-Type: application/json" \
     -d '{
           "description": "It was late at night and dark. There were no witnesses. I paid cash for the repairs already.",
           "incidentType": "ACCIDENT",
           "amount": 5000
         }' | python3 -m json.tool

# 3. Test a HIGH VALUE claim
echo -e "\n3️⃣  Sending HIGH VALUE claim..."
curl -X POST "http://localhost:8000/analyze" \
     -H "Content-Type: application/json" \
     -d '{
           "description": "My luxury car was stolen from the driveway.",
           "incidentType": "THEFT",
           "amount": 85000
         }' | python3 -m json.tool

echo -e "\n✅ Test complete."
