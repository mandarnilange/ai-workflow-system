# Refactor: Change /health endpoint to /healthz

## Objective
Change all occurrences of the `/health` endpoint to `/healthz` across the codebase.

## Tasks

- [ ] Identify all files referencing `/health`.
- [ ] Update `HealthRouter.ts` to use `/healthz`.
- [ ] Update `HealthRoutes.test.ts` to use `/healthz`.
- [ ] Update `HealthController.ts` if necessary.
- [ ] Update `GetHealthStatusUseCase.ts` if necessary.
- [ ] Run all tests to ensure no regressions.
- [ ] Run linting and type checking.
- [ ] Ensure 100% test coverage.
