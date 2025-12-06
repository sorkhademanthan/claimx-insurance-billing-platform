# 🧪 Phase 3 Testing Guide

Now that the UI is connected to the Backend, follow these steps to verify the full "First Notice of Loss" flow.

## 1. Prerequisites
Ensure your infrastructure is running (Docker):
```bash
docker ps
# You should see 'postgres' and 'minio' containers running.
```

## 2. Start the Backend
Open a terminal and run:
```bash
# Starts the NestJS API on http://localhost:3000
./start_dev.sh
# OR
npx nx serve auth-api
```

## 3. Start the Frontend
Open a **new** terminal and run:
```bash
# Starts the React Dashboard on http://localhost:4200
npx nx serve @claimx-ai/claim-dashboard
```

## 4. Manual Test Steps

1.  **Open Browser**: Go to [http://localhost:4200](http://localhost:4200).
2.  **Login**:
    *   **Email**: `demo@claimx.com`
    *   **Password**: `password123`
    *   *Note: If login fails, ensure you ran `npx ts-node prisma/seed.ts`.*
3.  **File a Claim**:
    *   You should see the "File a New Claim" form.
    *   **Policy**: Select the pre-loaded policy (e.g., `POL-12345678`).
    *   **Date**: Pick any date/time.
    *   **Type**: Select `ACCIDENT`.
    *   **Description**: Enter "Test claim via UI".
    *   **Evidence**: Click "Upload a file" and select a dummy image (JPG/PNG).
4.  **Submit**:
    *   Click the **Submit Claim** button.
5.  **Verification**:
    *   You should see an alert: `✅ Claim filed successfully!`.
    *   Check the **Backend Terminal**: You should see logs about "Claim Created" and "File Uploaded".
    *   Check **MinIO** (Optional): Go to `http://localhost:9001` (MinIO Console) to see the file in the `claim-evidence` bucket.

## 5. Verification (Backend & Storage)

### Option A: Database Check (Script)
We have created a script to fetch the latest claim from the database. Run:

```bash
npx ts-node verify_claim.ts
```

### Option B: MinIO Check (File Storage)
1.  Open **[http://localhost:9001](http://localhost:9001)** in your browser.
2.  Login with:
    *   User: `minioadmin`
    *   Pass: `minioadmin`
3.  Click **Buckets** on the left sidebar.
4.  Click **claim-evidence**.
5.  You should see your uploaded file listed there.

## Troubleshooting
*   **CORS Error**: If the browser console says "Blocked by CORS policy", ensure `app.enableCors()` is in `main.ts`.
*   **Connection Refused**: Ensure Backend is running on port 3000.
