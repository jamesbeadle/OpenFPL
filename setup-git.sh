#!/usr/bin/env bash
# One-shot: rename branch to main, commit the initial files, push to GitHub.
# Run from the repo root:  bash setup-git.sh
set -euo pipefail

cd "$(dirname "$0")"

# Clear any stale lock left by the sandbox
rm -f .git/index.lock

# Ensure the local branch is 'main' (GitHub's default)
current="$(git symbolic-ref --short HEAD 2>/dev/null || echo '')"
if [ "$current" != "main" ]; then
  git branch -m "${current:-master}" main 2>/dev/null || git checkout -b main
fi

# Ensure remote is set
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin https://github.com/jamesbeadle/OpenFPL.git
fi

git add -A
git commit -m "Initial commit: README, .gitignore, LICENSE, scope doc"

# If the GitHub repo was auto-initialised (e.g. with a README), reconcile first
git pull --rebase origin main || true

git push -u origin main

echo "Done. View at: https://github.com/jamesbeadle/OpenFPL"
