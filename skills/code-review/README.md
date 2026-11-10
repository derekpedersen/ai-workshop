# Code Review

A single review skill for evaluating implementation quality across correctness, security, maintainability, and testability.

## Purpose

Use this skill to review code for risk, quality, and improvement opportunities. It is designed to be practical and action-oriented rather than purely theoretical.

## When to use it

Use this skill when you want to:

- assess a change before merge
- check for logic or edge-case bugs
- review an implementation for security risk
- identify maintainability and refactoring opportunities
- evaluate whether tests cover the real behavior

## Review lenses

This skill is intentionally organized as one capability with several supporting review lenses:

- [Correctness](references/correctness.md) — logic, contracts, edge cases, and invariants
- [Security](references/security.md) — authentication, validation, secrets, trust boundaries, and unsafe defaults
- [Maintainability](references/maintainability.md) — clarity, complexity, naming, duplication, and design debt
- [Testing](references/testing.md) — coverage, meaningful assertions, regression protection, and test quality

## Review workflow

A strong review normally follows this order:

1. verify correctness and expected behavior
2. check for security and data-handling risk
3. examine maintainability and design quality
4. review test coverage and the confidence level of the change

## Typical outputs

- prioritized findings with severity
- code quality feedback with rationale
- bug risk analysis and likely failure modes
- refactoring and simplification suggestions
- test gaps and missing regression coverage

## Review principles

- focus on real behavior and user impact
- separate observation from recommendation
- identify the concrete risk, not just a stylistic preference
- suggest fixes that are small, clear, and testable
- prefer evidence and examples over vague criticism

## Related skill

- [Testing](../testing/README.md)
