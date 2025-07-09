#!/bin/bash

since_commit=$1
if [[ -z "$since_commit" ]]; then
  echo "Usage: $0 <since_commit>"
  exit 1
fi

# Get all changed .gd files between HEAD~2 and HEAD
changed_files=$(git diff --name-only "$since_commit" HEAD -- '*.gd')

# Exit if no files changed
if [[ -z "$changed_files" ]]; then
  echo "No .gd files changed since $since_commit."
  exit 0
fi

# Create a space-separated, double-quoted list
quoted_files=""
for file in $changed_files; do
  quoted_files+="\"$file\" "
done

# Trim trailing space
quoted_files=$(echo "$quoted_files" | sed 's/ *$//')

# Run gdlint with all files as arguments
echo "Running gdformat on changed files:"
echo "$quoted_files"
eval gdformat $quoted_files
