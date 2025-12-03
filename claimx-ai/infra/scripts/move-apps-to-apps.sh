#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <project1> [project2 ...]"
  echo "Example: $0 claim-service claim-dashboard"
  exit 1
fi

# Ensure apps directory exists
mkdir -p apps

# Helpers
has_nx_generator() {
  local plugin="$1"
  if npx nx list "$plugin" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

project_exists_dir() {
  local path="$1"
  [ -d "$path" ]
}

project_tracked_by_git() {
  local path="$1"
  local count
  count=$(git ls-files "$path" | wc -l || true)
  [ "${count}" -gt 0 ]
}

update_workspace_json_root() {
  # Updates workspace.json 'projects' root entries if they point to old path
  local old_root="$1"
  local new_root="$2"
  local workspace_file=""
  # Prefer workspace.json (older Nx versions)
  if [ -f workspace.json ]; then
    workspace_file="workspace.json"
  elif [ -f project.json ]; then
    # no centralized file
    workspace_file=""
  fi
  if [ -n "$workspace_file" ]; then
    if command -v jq >/dev/null 2>&1; then
      # backup
      cp "$workspace_file" "$workspace_file.bak"
      jq --arg oldRoot "$old_root" --arg newRoot "$new_root" \
        '.projects |= with_entries(.value.root |= (if . == $oldRoot then $newRoot else . end))' \
        "$workspace_file" > "$workspace_file.tmp" && mv "$workspace_file.tmp" "$workspace_file"
      echo "Updated $workspace_file root entries (if present) from $old_root -> $new_root."
    else
      echo "Note: jq not found; please update workspace.json project 'root' entries manually if needed."
      echo "Search entries referencing \"$old_root\" and change them to \"$new_root\"."
    fi
  fi
}

for project in "$@"; do
  src="$project"
  dst="apps/$project"

  echo "Processing: $project (src=$src -> dst=$dst)"

  # If project already under apps, skip
  if project_exists_dir "$dst"; then
    echo " - Already exists at $dst, skipping."
    continue
  fi

  # If source doesn't exist, skip with a helpful message
  if ! project_exists_dir "$src"; then
    echo " - Source directory $src not found at repo root."
    # Try to find if it exists with a different root in project.json entries (rare)
    if project_exists_dir "apps/$project"; then
      echo " - Found under apps/$project already, skipping."
      continue
    fi
    # If workspace lists this project, we will try the Nx move generator via projectName
    if npx nx show project "$project" >/dev/null 2>&1 || npx nx show project "@$(node -p \"require('./package.json').name\")/$project" >/dev/null 2>&1; then
      echo " - Found as workspace project; attempting Nx generator-based move."
      moved=0
      if has_nx_generator "@nrwl/workspace"; then
        if npx nx g @nrwl/workspace:move --projectName="$project" --destination="$dst" --skipInstall; then
          moved=1
        fi
      fi
      if [ "$moved" -eq 0 ] && has_nx_generator "@nx/workspace"; then
        if npx nx g @nx/workspace:move --projectName="$project" --destination="$dst" --skipInstall; then
          moved=1
        fi
      fi
      if [ "$moved" -eq 1 ]; then
        echo " - Successfully moved workspace project: $project"
      else
        echo " - Nx generator did not move the project; please inspect 'npx nx show project $project' and adjust workspace config manually."
      fi
    else
      echo " - Workspace doesn't list $project as a project name. Skipping."
    fi
    continue
  fi

  # Source dir exists; try Nx move via projectName mapping first if project exists in workspace
  moved=0
  if npx nx show project "$project" >/dev/null 2>&1 || npx nx show project "@$(node -p \"require('./package.json').name\")/$project" >/dev/null 2>&1; then
    echo " - Found workspace project; trying Nx move generators..."
    if has_nx_generator "@nrwl/workspace"; then
      if npx nx g @nrwl/workspace:move --projectName="$project" --destination="$dst" --skipInstall; then
        echo " - Moved via @nrwl/workspace generator."
        moved=1
      fi
    fi
    if [ "$moved" -eq 0 ] && has_nx_generator "@nx/workspace"; then
      if npx nx g @nx/workspace:move --projectName="$project" --destination="$dst" --skipInstall; then
        echo " - Moved via @nx/workspace generator."
        moved=1
      fi
    fi
  fi

  # If Nx failed or not applicable, fallback to git mv or mv & git add
  if [ "$moved" -eq 0 ]; then
    echo " - Nx move not possible or not detected. Falling back to Git move or manual move."

    # If tracked by git, use git mv
    if project_tracked_by_git "$src"; then
      echo " - Detected tracked files under $src; running git mv"
      git mv "$src" "$dst"
      if [ -d "${src}-e2e" ]; then
        if project_tracked_by_git "${src}-e2e"; then
          git mv "${src}-e2e" "apps/${src}-e2e" || true
        else
          mkdir -p "apps/${src}-e2e"
          mv -v "${src}-e2e"/* "apps/${src}-e2e" || true
          git add "apps/${src}-e2e" || true
        fi
      fi
    else
      echo " - No tracked files in $src. Using regular move and tracking:"
      mkdir -p "$dst"
      # Move both visible and hidden files
      shopt -s dotglob || true
      mv -v "$src"/* "$dst"/ || true
      # If src has no files, this will create empty dst. Remove empty dir
      if [ -z "$(ls -A "$dst" 2>/dev/null)" ]; then
        rmdir "$dst" || true
        echo " - $src contained no files to move (empty)."
      else
        git add "$dst" || true
      fi
      # Move e2e if present
      if [ -d "${src}-e2e" ]; then
        mkdir -p "apps/${src}-e2e"
        mv -v "${src}-e2e"/* "apps/${src}-e2e"/ || true
        git add "apps/${src}-e2e" || true
      fi
    fi

    # Update workspace.json root paths if present
    update_workspace_json_root "$src" "$dst"

    echo " - Move fallback completed for $project. Please run 'git status' to review changes and commit."
  fi

  echo "Finished processing $project."
done

echo ""
echo "Done. Validate workspace:"
echo "  npx nx graph || echo 'nx graph failed; validate workspace configuration manually'"
echo "  npx nx show project <project> # to confirm the project's new root and sourceRoot if needed"
echo "If any project still points to the old root, search and update workspace.json (or project.json) entries accordingly."
