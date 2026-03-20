#!/bin/sh

set -eu

# Check if a semantic-release configuration already exists in the workspace.
for file in \
  .releaserc \
  .releaserc.yaml \
  .releaserc.yml \
  .releaserc.json \
  .releaserc.js \
  .releaserc.cjs \
  .releaserc.mjs \
  release.config.js \
  release.config.cjs \
  release.config.mjs; do
  if [ -f "${file}" ]; then
    echo "Found existing semantic-release config: ${file}"
    exit 0
  fi
done

if [ -f package.json ] && grep -q '"release"' package.json; then
  echo "Found existing semantic-release config in package.json"
  exit 0
fi

# No existing config found — emit the default.
echo "No semantic-release config found, emitting default .releaserc.yml"

cat >.releaserc.yml <<'EOF'
branches: main

plugins:
  - '@semantic-release/git'
  - '@semantic-release/github'

  - - '@semantic-release/commit-analyzer'
    - preset: conventionalCommits
      releaseRules:
        - breaking: true
          release: major
        - type: feat
          release: minor
        - type: fix
          release: patch
        - type: perf
          release: patch
        - type: revert
          release: patch
        - type: docs
          release: patch
        - type: style
          release: false
        - type: test
          release: false
        - type: build
          release: false
        - type: ci
          release: false
        - type: chore
          release: false
        - type: chore
          scope: deps
          release: patch

  - - '@semantic-release/release-notes-generator'
    - preset: conventionalCommits
      presetConfig:
        types:
          - type: feat
            section: Features
          - type: fix
            section: Fixes
          - type: perf
            section: Performance
          - type: revert
            section: Revert
          - type: docs
            section: Documentation
          - type: style
            section: Style
          - type: test
            section: Tests
          - type: build
            section: Build System
          - type: ci
            section: CI
          - type: chore
            section: Chores
          - type: chore
            scope: deps
            section: Dependencies
EOF
