# Copilot instructions for this workshop

## Core repo intent

This repository is a workshop for organizing reusable AI skill libraries, wrapper scripts, and reference material. It is not a general-purpose machine tool installer.

## Reference package pattern

Each reference entry should follow this pattern:

- `install.sh` installs the real skill library or base package when a verified upstream source exists.
- `wrappers/` contains assistant-specific setup scripts such as `copilot.sh`, `claude.sh`, and `codex.sh`.
- the wrapper script must call the real install path, not reimplement the base setup.
- do not invent upstream repos or skill libraries that have not been verified.

## Rule for upstream skill libraries

Only reference an upstream skill library when it is a real, known repository and the project intends to use it.

If no verified upstream library exists yet:

- leave the package as a placeholder
- print a clear message in the install script stating that no upstream library is currently referenced
- do not fabricate a repo URL or fake library name
- keep the Go package as the example of the correct pattern

## Naming convention

- use `install.sh` for the primary setup
- use `wrappers/<assistant>.sh` for wrapper-specific installs
- do not create top-level assistant scripts like `copilot.sh` or `claude.sh` beside `install.sh`

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
