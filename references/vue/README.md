# Vue reference

This directory holds the Vue-specific skill library reference for the workshop.

## Purpose

This repo is not for installing local machine tooling. Vue itself belongs in a separate project.

This package is for installing an upstream frontend/Vue skill library and then wiring it into the AI wrapper you are using.

## Upstream source

This workshop uses the Vue/frontend skills library from:

- antfu/skills

This is the real upstream frontend-focused skill repository for the workshop and follows the same install pattern as the Go reference.

## Install the frontend/Vue skill pack

Install everything:

```bash
./install.sh
```

Install only a specific skill if you have one selected from the upstream library:

```bash
./install.sh --skill vue-component-architecture
./install.sh --skill frontend-state-management
```

## Optional wrapper scripts

Use the wrapper for the AI client you are currently running:

```bash
./wrappers/copilot.sh
./wrappers/claude.sh
./wrappers/codex.sh
./wrappers/cursor.sh
```

These wrappers are intentionally thin. They invoke the same upstream skill install without mixing the base library setup with assistant-specific logic.

## Validation

After installing, confirm the library is available:

```bash
npx skills list
```

## Notes

This package follows the same model as the Go reference: install the upstream skill library here, and keep wrapper setup separate.
