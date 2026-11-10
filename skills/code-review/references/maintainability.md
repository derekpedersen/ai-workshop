# Maintainability review

## Purpose

Assess whether the code is clear, readable, and sustainable for the people who will maintain it next.

## What to look for

- unclear names or misleading abstractions
- functions that do too much or hide too many responsibilities
- repeated logic that should be extracted or centralized
- deep nesting and low readability
- complex branching that obscures business intent
- inconsistent patterns or inconsistent error-handling models
- missing or outdated documentation around important decisions

## Review questions

- Can a new engineer understand this without extensive context?
- Is the code consistent with the surrounding design language?
- Are responsibilities separated cleanly?
- Is the complexity justified by the problem, or is it accidental?
- Is the code easier to change safely than the previous version?

## Common findings

- high cognitive load caused by nested conditionals or hidden side effects
- duplicated logic that should be a shared helper
- naming that reflects implementation detail rather than intent
- configuration or business rules hardcoded instead of expressed clearly
- large functions that mix orchestration, validation, and side effects

## Good review outcome

The review should point to structural improvements that reduce future cost without bloating the codebase or over-optimizing prematurely.

## Suggested prompt

"Review this code for maintainability. Focus on clarity, complexity, naming, responsibility boundaries, duplication, and long-term change cost. Suggest a small set of high-value improvements with practical examples."
