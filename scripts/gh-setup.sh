#!/usr/bin/env bash
# gh-setup.sh — Create labels and open pre-drafted issues for yield-routes-docs
set -euo pipefail

REPO="Yield-routes/Yield-routes-Docs"

echo "==> Creating labels in $REPO..."
gh label create "good first issue"  --color "7057ff" --description "Good for newcomers — no deep Soroban knowledge required"             --repo "$REPO" --force
gh label create "help wanted"       --color "008672" --description "Extra attention is needed"                                      --repo "$REPO" --force
gh label create "documentation"     --color "0075ca" --description "Improvements or additions to documentation"                     --repo "$REPO" --force
gh label create "enhancement"       --color "a2eeef" --description "New feature or improvement to existing functionality"            --repo "$REPO" --force
echo "    Labels created."

echo ""
echo "==> Opening issues..."

ISSUES_DIR=".github/ISSUES"

declare -A ISSUE_MAP
ISSUE_MAP["docs-explain-sep56-in-plain-english.md"]="Write a plain-English explainer: what is SEP-56 and why does it matter?|documentation,good first issue,help wanted"

CREATED=0
for file in "${!ISSUE_MAP[@]}"; do
  IFS='|' read -r title labels <<< "${ISSUE_MAP[$file]}"
  body_file="$ISSUES_DIR/$file"
  if [[ ! -f "$body_file" ]]; then
    echo "    SKIP: $body_file not found"
    continue
  fi
  echo "    Creating: $title"
  gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body-file "$body_file" \
    --label "$labels"
  sleep 1
  ((CREATED++))
done

echo ""
echo "==> Summary: created $CREATED issue(s) in $REPO"
