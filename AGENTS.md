# AGENTS.md

This repository is the AI Workshop. It is organized around reusable skills, specialized agents, and repeatable workflows.

## Purpose

Use this repo as a learning and experimentation space for AI-assisted product, architecture, and engineering work.

## Conventions

- Keep skills focused and reusable.
- Keep agents role-based and task-oriented.
- Keep workflows end-to-end and clear.
- Document prompts and references in their respective directories.
- Favor modular structure over monolithic implementations.

## Project structure

- `skills/`: reusable capability modules
- `agents/`: role-oriented AI helpers
- `workflows/`: end-to-end task flows
- `prompts/`: reusable prompts and templates
- `references/`: supporting notes and resources

## Expectations

When adding new work to this repo:

1. place capability-specific content in the matching `skills/` folder
2. add or update a role-specific agent in `agents/` when needed
3. describe end-to-end execution in `workflows/`
4. keep README files clear and concise
5. prefer upstream specialist skill libraries for well-established domain knowledge
6. use this repo as the central workshop layer for curation, workflows, prompts, and local orchestration
7. keep the workshop easy to extend

## External skill references

When a mature upstream library already covers a domain well, prefer referencing and integrating it rather than reimplementing it locally.

Examples include:

- Samber Go skills: https://github.com/samber/cc-skills-golang/

Use this repo to connect those upstream capabilities to your own agents, workflows, and project conventions.
