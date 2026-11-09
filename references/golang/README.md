# Go reference

This directory holds the Go-specific reference material and setup scripts used by the workshop.

## Purpose

Use this package to keep Go tooling and installation details together without cluttering the repo root or the general references index.

The goal is to separate:

- tool documentation and background notes
- installation commands for the upstream Go skill pack
- optional workflow wrappers for editor or Copilot integration

## Upstream source

This workshop uses the upstream Go skill library from:

- samber/cc-skills-golang

It is a curated set of Go-focused skills for project layout, testing, architecture, docs, refactoring, and related developer workflows.

## Install the Go skill pack

This package uses `install.sh` because it installs an upstream skill library, not the Go toolchain itself.

Install everything:

```bash
./install.sh
```

Install only a specific skill:

```bash
./install.sh --skill golang-project-layout
./install.sh --skill golang-testing
```

Or pass additional arguments directly to the underlying command:

```bash
./install.sh --all
./install.sh --skill golang-project-layout
```

## Optional wrapper scripts

The repo keeps the actual skill installation separate from any AI wrapper-specific setup so that the core docs and installation behavior stay clear.

To use the Copilot wrapper for this package:

```bash
./wrappers/copilot.sh
```

This script is intentionally thin: it runs the same upstream Go skill installation flow with a friendlier entry point for local editor and workshop workflows.

## Validate the installation

After installing, verify the library is available:

```bash
npx skills list
```

If you want to inspect the installed skill set only for Go-related entries, you can filter the output:

```bash
npx skills list | grep -i golang
```

## Notes

This reference package is intentionally scoped to the Go toolchain and the upstream Go skill library. Future tooling references can follow the same folder pattern so the workshop remains easy to extend.
