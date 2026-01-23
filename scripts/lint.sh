#!/usr/bin/env bash
set -e

ruff check .
black --check .
