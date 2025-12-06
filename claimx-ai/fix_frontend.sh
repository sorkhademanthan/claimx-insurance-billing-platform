#!/bin/bash

echo "🚚 Moving frontend files to the correct project: @claimx-ai/claim-dashboard..."

# Define paths
WRONG_PATH="apps/claimx-fe/src"
CORRECT_PATH="apps/claim-dashboard/src"

# Ensure target directories exist
mkdir -p "$CORRECT_PATH/app"
mkdir -p "$CORRECT_PATH/utils"

# Move the files we created
# Note: We use cp instead of mv to be safe, or mv if you prefer.
if [ -d "$WRONG_PATH" ]; then
    echo "Copying App component..."
    cp "$WRONG_PATH/app/app.tsx" "$CORRECT_PATH/app/app.tsx"
    
    echo "Copying Login component..."
    cp "$WRONG_PATH/app/login.tsx" "$CORRECT_PATH/app/login.tsx"
    
    echo "Copying Claim Form..."
    cp "$WRONG_PATH/app/claim-form.tsx" "$CORRECT_PATH/app/claim-form.tsx"
    
    echo "Copying API Utils..."
    cp "$WRONG_PATH/utils/api.ts" "$CORRECT_PATH/utils/api.ts"
    
    echo "✅ Files moved successfully."
else
    echo "⚠️  Could not find source files in $WRONG_PATH. Please check if you created them."
fi

echo "🚀 Starting the Frontend..."
npx nx serve @claimx-ai/claim-dashboard
