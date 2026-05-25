#!/usr/bin/env bash
# Auto-runs in Terminal when double-clicked from Finder.
set -e

cd "$(dirname "$0")"
echo "Working in: $(pwd)"
echo

# Clear any stale lock left by the sandbox
rm -f .git/index.lock

# Ensure the local branch is 'main'
current="$(git symbolic-ref --short HEAD 2>/dev/null || echo '')"
if [ "$current" != "main" ]; then
  if [ -n "$current" ]; then
    git branch -m "$current" main
  else
    git checkout -b main
  fi
fi

# Ensure remote is set
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin https://github.com/jamesbeadle/OpenFPL.git
fi

echo "--- Staging files ---"
git add -A
git status --short
echo

echo "--- Committing ---"
git commit -m "Initial commit: README, .gitignore, LICENSE, scope doc" || echo "(nothing to commit)"
echo

echo "--- Pulling/rebasing in case GitHub auto-created a README ---"
git pull --rebase origin main || echo "(no remote branch yet, or rebase skipped)"
echo

echo "--- Pushing to GitHub ---"
git push -u origin main

echo
echo "Done. View at: https://github.com/jamesbeadle/OpenFPL"
echo
echo "(You can close this Terminal window.)"
