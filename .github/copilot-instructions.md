# Copilot instructions for this workshop

## Core repo intent

This repository is a workshop for organizing reusable AI skill libraries, wrapper scripts, and reference material. It is not a general-purpose machine tool installer.

## Install pattern

The workshop supports both external reference installs and local workshop skill installs.

- a root-level `install.sh` may install either external reference packages or local skill content from this repo
- `references/*/install.sh` installs real external skill libraries when a verified upstream source exists
- `references/*/wrappers/` contains assistant-specific setup scripts such as `copilot.sh`, `claude.sh`, and `codex.sh`
- the wrapper script must call the real install path, not reimplement the base setup
- do not invent upstream repos or skill libraries that have not been verified
- the root installer is allowed to delegate to both external references and local workshop skill directories

## Head vs headless lifecycle pattern

All lifecycle entry points should follow the same pattern:

- if no arguments are passed, the script prompts interactively
- if arguments are passed, the script runs in headless mode without prompting
- this applies to `install.sh`, `uninstall.sh`, and `list.sh`
- use the same option naming across scripts so behavior stays predictable

## Rule for upstream skill libraries

Only reference an upstream skill library when it is a real, known repository and the project intends to use it.

If no verified upstream library exists yet:

- leave the package as a placeholder
- print a clear message in the install script stating that no upstream library is currently referenced
- do not fabricate a repo URL or fake library name
- keep the Go package as the example of the correct pattern

## Naming convention

- use `install.sh` for the primary setup at the package or repo root
- use `uninstall.sh` for the matching removal flow at the package or repo root
- use `list.sh` for inventory and inspection of installed capabilities
- use `wrappers/<assistant>.sh` for wrapper-specific installs
- do not create top-level assistant scripts like `copilot.sh` or `claude.sh` beside `install.sh`
- the root installer may orchestrate both local repo skills and external references without forcing a single-install-only model
- the same head/headless convention applies to all three lifecycle scripts

## Validation expectations

Before treating a package as complete:

- run shell syntax validation on all scripts in the package
- verify the package does not contain invented repo URLs
- ensure the documented install path matches the actual file layout

## Examples

Valid pattern:

```text
references/
  golang/
    install.sh
    wrappers/
      copilot.sh
      claude.sh
      codex.sh
```

Placeholder pattern:

```text
references/
  python/
    install.sh
    wrappers/
      copilot.sh
      claude.sh
      codex.sh
```

When a real upstream Python library is selected later, replace the placeholder message with the actual repo and installation steps.
