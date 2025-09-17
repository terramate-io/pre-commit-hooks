#!/usr/bin/env bash

set -e

if ! command -v terramate >/dev/null 2>&1; then
  echo >&2 "terramate is not available on this system."
  echo >&2 "Please install it by running 'go install github.com/terramate-io/terramate/cmd/terramate@latest'"
  exit 1
fi

terramate generate
