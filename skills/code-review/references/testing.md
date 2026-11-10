# Testing review note

This guidance is intentionally shared with the broader testing skill, not duplicated as a separate canonical document.

For the full guidance on how to evaluate test quality, coverage, and regression protection, see:

- [Testing](../../testing/README.md)

## Code-review focus

When reviewing a change, check whether the implementation is protected by tests that verify real behavior rather than implementation details.

Key questions:

- Does the change have meaningful coverage for the expected behavior?
- Are edge cases, failure modes, and boundaries covered?
- Do the tests assert the public contract or only internals?
- Is the lack of coverage a real risk to release confidence?

A good review outcome is a short, actionable note that says whether the change is adequately tested and what specific regression scenarios are still missing.
