# Security review

## Purpose

Assess whether the code introduces risk through unsafe defaults, poor validation, untrusted input handling, missing authorization checks, or weak operational practices.

## What to look for

- missing input validation or sanitization
- unsafe handling of secrets, environment variables, or credentials
- authorization or authentication checks that are bypassable or inconsistent
- untrusted data being used in SQL, shell commands, file paths, or URLs
- weak crypto or insecure defaults
- deserialization or parsing behavior that is risky in untrusted contexts
- error messages that leak sensitive information

## Review questions

- Where does untrusted input enter the system?
- What trust boundaries exist, and are they enforced?
- Are secrets stored or logged safely?
- Are authorization and access checks applied consistently?
- Are defaults secure, or do they silently widen exposure?

## Common findings

- validation only on the client side or not at the system boundary
- secret material left in logs, config, or stack traces
- missing checks for privileged operations
- overly broad file or network permissions
- unsafe dependency or package version choices without review

## Good review outcome

The reviewer should identify the real attack surface, clarify the likely impact, and suggest a minimal fix that reduces risk without overengineering the solution.

## Suggested prompt

"Review this change for security risk. Focus on input validation, trust boundaries, secret handling, authorization checks, and unsafe defaults. Flag only issues that are likely to matter in production and suggest concrete mitigation steps."
