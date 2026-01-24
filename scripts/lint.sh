#!/usr/bin/env bash
set -e

# Python linting
ruff check .
black --check .

# Markdown linting
npx markdownlint "**/*.md"

# Prettier formatting check
npx prettier --check "**/*.{md,yml,yaml,json}"
