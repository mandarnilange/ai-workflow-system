# Feature: API User Detail Endpoint

**Status**: Completed
**Started**: 2025-11-11
**Completed**: 2025-11-11
**Priority**: Medium

## Overview

Expose `/api/users/:id` in the Express API so clients can fetch a specific mock user record. This complements the existing list endpoint and allows UI work that requires drilling into an individual user profile.

## Tasks

### Research & Planning
- [x] Review existing `/api/users` flow, fixtures, and DI wiring
- [x] Plan detail endpoint behavior (+ 404 handling) across layers

### Domain Layer (TDD)
- [x] Add fixture helper tests for lookup by id
- [x] Implement fixture lookup helpers

### Application Layer (TDD)
- [x] Write `GetUserByIdUseCase` tests (user + not found)
- [x] Implement `GetUserByIdUseCase`

### Infrastructure Layer (TDD)
- [x] Add repository tests for `findById`
- [x] Implement `findById` on in-memory repository

### Presentation Layer (TDD)
- [x] Add controller tests for new detail handler
- [x] Implement controller detail handler
- [x] Add route tests covering success + 404 JSON payloads
- [x] Register `/api/users/:id` route

### DI Layer
- [x] Extend container wiring for new use case/controller

### Validation
- [x] Run test suite (100% coverage required)
- [x] Run architecture validator
- [x] Run linting/static analysis
- [x] Update documentation

## Progress

- Total Tasks: 18
- Completed: 18
- In Progress: 0
- Blocked: 0
- Completion: 100%

## Notes

### Key Decisions
- Reused fixture helpers for detail lookups to keep repository lean.
- UsersController now exposes `show` method returning explicit 404 JSON on `UserNotFoundError`.

### Blockers
- None

### References
- Commits: Pending
- Related Issues: N/A
- Related PRs: N/A

## Test Coverage

- Tests Added: Pending
- Test Suites: Pending
- Coverage: Pending

## Files Changed

### Created
- Pending

### Modified
- Pending

## Related Work

- Related Features: `.spec/002-feature-api-users-endpoint.md`
- Dependencies: None
- Dependents: Future detail + update flows
