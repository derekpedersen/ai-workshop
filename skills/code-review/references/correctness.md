# Correctness review

## Purpose

Check whether the code does the right thing under the intended conditions and does not violate the stated contract.

## What to look for

- mismatches between expected behavior and actual logic
- off-by-one errors, boundary condition bugs, and invalid state handling
- broken invariants, concurrency assumptions, or race-prone patterns
- incorrect handling of nulls, empty values, defaults, and retries
- APIs that silently accept bad data or return surprising results
- forgotten error paths or inconsistent failure behavior

## Review questions

- Does the implementation match the expected behavior from the requirement or contract?
- Are edge cases handled intentionally and explicitly?
- Are inputs validated at the correct boundary?
- Is the failure behavior consistent and diagnosable?
- Are assumptions documented, or are they hidden in the code?

## Common findings

- logic that appears correct but fails on empty, zero, or negative values
- conditions that are reversed or duplicated in a way that changes behavior only in edge cases
- state updates that happen in the wrong order
- retries or timeouts that create inconsistent final states
- code that passes tests but violates the real-world contract of the API or feature

## Good review outcome

The reviewer should be able to state:

- the intended behavior
- the concrete risk or failure mode
- the specific evidence in the code path
- the suggested fix or validation step

## Suggested prompt

"Review this change for correctness. Focus on logic, edge cases, contract violations, and any mismatch between implementation and expected behavior. Prioritize findings and include concrete examples of likely failure modes."
