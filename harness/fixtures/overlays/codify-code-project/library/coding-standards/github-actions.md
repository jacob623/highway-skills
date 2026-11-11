# GitHub Actions Coding Standard

## Scope

GitHub Actions workflows in `.github/workflows/*.yml`.

## File and Folder Structure

1. `.github/workflows/<name>.yml`

## Rules

1. Actions must be pinned to a full commit hash.
2. Secrets must come from repository secrets only.
3. Each job must set a timeout in minutes.

## Tests

Tests: not required
