# Testing

A skill for validating behavior, identifying risk, and improving software confidence.

## Purpose

Use this skill to create and evaluate tests across unit, integration, and system levels. This is the canonical place for testing guidance that should be reusable across multiple workflows, review activities, and engineering tasks.

## Core test-quality questions

- What behavior must be validated?
- What edge cases, failure modes, and invalid inputs matter?
- Do the tests assert real outcomes rather than implementation details?
- Are the tests stable, readable, and maintainable?
- Will a regression be caught before release?

## Review lens for testing quality

When evaluating a change for testing quality, look for:

- missing tests for risky or newly introduced logic
- assertions that check internals instead of externally visible behavior
- flaky tests, brittle setup, or noisy environment dependencies
- no coverage for failure paths, edge cases, boundary conditions, or invalid inputs
- strong production code but weak regression protection

## Good test design patterns

- test the public contract, not implementation details
- cover happy path, edge cases, and failure states
- prefer meaningful assertions and focused fixtures
- keep tests readable and specific to the behavior they protect
- reproduce the real bug scenario in the test when fixing a defect

## Typical outputs

- test plans
- unit tests
- integration tests
- regression tests
- smoke tests
- quality validation notes
- review notes on test coverage and confidence

## Related review skill

- [Code Review](../code-review/README.md)
