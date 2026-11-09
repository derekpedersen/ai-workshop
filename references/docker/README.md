# Docker reference

This directory holds the Docker-specific skill library reference for the workshop.

## Purpose

This repo is not for installing local machine tooling. Docker itself belongs in a separate project.

This package is for installing an upstream Docker skill library and then wiring it into the AI wrapper you are using.

## Upstream source

This workshop uses the Docker Skills library from:

- docker/skills

This is the real upstream Docker-focused skill repository for the workshop and follows the same install pattern as the Go reference.

## Install the Docker skill pack

Install everything:

```bash
./install.sh
```

Install only a specific skill if you have one selected from the upstream library:

```bash
./install.sh --skill docker-compose
./install.sh --skill docker-security
```

## Optional wrapper scripts

Use the wrapper for the AI client you are currently running:

```bash
./wrappers/copilot.sh
./wrappers/claude.sh
./wrappers/codex.sh
```

These wrappers are intentionally thin. They invoke the same upstream skill install without mixing the base library setup with assistant-specific logic.

## Validation

After installing, confirm the library is available:

```bash
npx skills list
```

## Notes

This package follows the same model as the Go reference: install the upstream skill library here, and keep wrapper setup separate.
