# AI Workshop

This repository is my AI Workshop: a structured space for building, testing, and refining AI-driven skills, agents, and workflows.

The goal is to create a reusable, modular environment for experimenting with practical AI patterns across product, architecture, engineering, and delivery work.

## Repository structure

```text
ai-workshop/
├── skills/
│   ├── project-planning/
│   ├── requirements-discovery/
│   ├── architecture-design/
│   ├── frontend-development/
│   ├── backend-development/
│   ├── code-review/
│   └── testing/
│
├── agents/
│   ├── product-manager/
│   ├── architect/
│   └── developer/
│
├── workflows/
│   ├── new-project/
│   ├── feature-development/
│   └── code-review/
│
├── prompts/
├── references/
└── README.md
```

## Purpose

This workshop is organized to support:

- reusable skills for focused technical and product work
- specialized agents that embody different roles and responsibilities
- repeatable workflows for common delivery patterns
- prompt libraries and reference materials for experimentation
- practical learning through real project-oriented examples

## Upstream skill sources

This repository acts as the central workshop hub for organizing, curating, and applying reusable AI skills. It is not intended to replace proven upstream skill libraries; instead, it brings them together with project-specific workflows and prompts.

For Go-focused capabilities, this workshop uses [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang/) as a primary upstream source of reusable skills. The repository can be used as a central installation point for Go knowledge, while this workshop adds custom workflow orchestration, role-based agents, and project-specific patterns.

Example install patterns:

```bash
npx skills add https://github.com/samber/cc-skills-golang --all
# or a specific skill
npx skills add https://github.com/samber/cc-skills-golang --skill golang-project-layout
```

This keeps the workshop focused on integration, selection, and usage, while avoiding the maintenance burden of re-creating large upstream skill libraries from scratch.

## Skill installation pattern

This repo is intended to be the central place where you install, inspect, and curate external skill sources for your tooling and workflows.

```bash
# install all Go skills from the upstream library
npx skills add https://github.com/samber/cc-skills-golang --all

# install only a specific skill needed for a task
npx skills add https://github.com/samber/cc-skills-golang --skill golang-project-layout
npx skills add https://github.com/samber/cc-skills-golang --skill golang-testing
```

This lets the workshop stay lightweight while still giving you access to mature upstream skill sets when you need them.

## Skills

The `skills/` section contains focused capability modules. Each skill is intended to represent a reusable pattern or competency, such as:

- project planning
- requirements discovery
- architecture design
- frontend development
- backend development
- code review
- testing

These are designed to be composable and reusable across multiple workflows and agents.

## Agents

The `agents/` section contains role-based assistants that coordinate and apply skills in context. Examples in this workshop include:

- product-manager
- architect
- developer

Each agent is intended to represent a specific perspective or execution role in the software lifecycle.

## Workflows

The `workflows/` section captures end-to-end delivery patterns such as:

- new-project
- feature-development
- code-review

These workflows connect skills and agents into structured execution paths for common tasks.

## prompts and references

- `prompts/` is for reusable prompts, templates, and role instructions.
- `references/` is for research, design notes, external resources, and supporting documentation.

## How to use this workshop

This repository is meant to evolve over time. The pattern is simple:

1. define a useful skill
2. assign it to an agent role
3. connect the combination to a workflow
4. capture prompts and references that support the work

The structure is intentionally modular so new capabilities can be added without disrupting the overall system.

## Current focus

This is a living workshop and a foundation for future AI-assisted development patterns. The current structure is intended to grow into a practical library of reusable capabilities and team workflows.

## CI and validation

This repository now includes a Jenkins pipeline defined in `Jenkinsfile`.

Because this project is script-first, CI focuses on shell quality and workflow behavior instead of build artifacts:

- shell syntax validation
- shellcheck linting
- workshop policy checks for script layout and wrapper delegation
- local lifecycle smoke test (`install.sh` -> `list.sh` -> `uninstall.sh`)
- optional external reference checks behind `RUN_EXTERNAL_SKILL_CHECKS=true`

Pipeline helper scripts are intentionally stored in `.ci/` to indicate they are repository automation utilities, not workshop skill content.

### Jenkins agent prerequisites

Required for default pipeline stages:

- `bash`
- `shellcheck`

Optional for external reference validation stage (`RUN_EXTERNAL_SKILL_CHECKS=true`):

- `node`
- `npx`

Run checks locally:

```bash
.ci/lint-bash-syntax.sh
.ci/lint-shellcheck.sh
.ci/verify-workshop-policy.sh
.ci/smoke-local-lifecycle.sh
```

If you want to run the optional external check locally:

```bash
.ci/smoke-external-references.sh
```
