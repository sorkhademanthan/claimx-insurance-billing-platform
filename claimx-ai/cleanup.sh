#!/bin/bash

echo "🗑️  Cleaning up unused frontend folder..."

# Check if the folder exists before trying to delete it
if [ -d "apps/claimx-fe" ]; then
    rm -rf apps/claimx-fe
    echo "✅ Successfully deleted 'apps/claimx-fe'."
else
    echo "ℹ️  Folder 'apps/claimx-fe' does not exist (already deleted)."
fi
