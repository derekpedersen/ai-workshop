# References

This directory is intended for supporting materials, research, references, examples, and background information.

Use it for:

- design notes
- architecture references
- implementation examples
- AI and tooling resources
- internal documentation

## External skill libraries

This workshop is designed to act as a central hub for reusable skills, while still leveraging mature upstream libraries when they already exist.

### Go skills

- [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang/) — curated Go-focused skill library covering project setup, testing, architecture, docs, security, and more.
- [golang reference package](golang/README.md) — local workshop guide and scripts for installing the upstream Go skill library and related setup flows.

### Tool-specific reference packages

- [Python reference](python/README.md) — placeholder package; no upstream Python skill library is currently referenced.
- [Docker reference](docker/README.md) — placeholder package; no upstream Docker skill library is currently referenced.
- [Vue reference](vue/README.md) — placeholder package; no upstream Vue/frontend skill library is currently referenced.

## Script naming convention

Each reference package uses a consistent two-step pattern:

- `install.sh` is the primary installer for that skill pack or reference set.
- `wrappers/` contains assistant-specific setup scripts such as Copilot, Claude, Codex, or other editor integrations.

This workshop is not for installing local machine toolchains. That belongs in a separate project. This repo is for installing upstream skill libraries and then wiring them into whichever AI wrapper you use.

Example:

```text
references/
  python/
    install.sh
    wrappers/
      copilot.sh
      claude.sh
      codex.sh
```

This lets the same skill base be installed into different AI wrappers without duplicating the underlying setup logic.

These upstream resources should be treated as reusable building blocks. This workshop adds the local curation layer: project-specific workflows, agents, prompts, and operating conventions.

## Example workflow

A common pattern in this repo is:

1. install the upstream Go skill pack
2. select the relevant skill(s) for the task
3. apply the matching workflow and agent role
4. keep project-specific notes, prompts, and conventions here

Example:

```bash
npx skills add https://github.com/samber/cc-skills-golang --all
# then use a project workflow for:
# - new project setup
# - refactoring a Go service
# - testing and review
```

This keeps the workshop as the central coordination point while relying on upstream libraries for domain depth.
