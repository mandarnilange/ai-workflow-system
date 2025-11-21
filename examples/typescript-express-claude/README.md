# TypeScript + Express.js Example - Sample Implementation

This is a **sample implementation** demonstrating the AI Workflow System with a TypeScript REST API project using Express.js and Clean Architecture.

## Sample Implementation

**Initial Instruction Given:**
> "Create a health endpoint and return json giving http status, timestamp and message"

**What Was Achieved:**
- ✅ Complete TypeScript + Express.js project initialized from scratch
- ✅ Health endpoint implemented at `GET /healthz` returning JSON with:
  - HTTP status (200 OK)
  - Timestamp (current date/time)
  - Message ("Service is healthy")
- ✅ Clean Architecture implementation:
  - Application Layer: `GetHealthStatus` use case
  - Presentation Layer: `HealthController` and Express app setup
  - DI Layer: Dependency injection container
- ✅ 100% test coverage (3/3 tests passing)
  - Unit tests for use case and controller
  - E2E test for the health endpoint
- ✅ TDD workflow followed (Red-Green-Refactor for every component)
- ✅ Zero architecture violations
- ✅ Zero linting errors
- ✅ Complete task tracking in `.spec/` directory

This demonstrates how the AI Workflow System guides implementation from a simple request to a production-ready, fully tested feature following Clean Architecture principles.

## Project Structure

```
project/
├── src/
│   ├── domain/              # Pure business logic (no dependencies)
│   ├── application/         # Use cases (depends on domain only)
│   ├── infrastructure/      # Implementations (DB, external APIs)
│   ├── presentation/        # Controllers, routes (HTTP layer)
│   └── di/                  # Dependency injection container
├── tests/                   # Mirror of src/ structure
│   ├── domain/
│   ├── application/
│   ├── infrastructure/
│   ├── presentation/
│   └── e2e/
├── dist/                    # Build output
└── .workflow/               # Workflow system
    ├── config.yml           # This configuration
    └── playbooks/           # Workflow playbooks
```

## Tech Stack

- **Language**: TypeScript (strict mode)
- **Framework**: Express.js
- **Testing**: Jest with ts-jest
- **Linting**: ESLint
- **Formatting**: Prettier
- **Type Checking**: TypeScript compiler (tsc)

## Quality Standards

- ✅ **100% test coverage** (statements, branches, functions, lines)
- ✅ **Zero architecture violations**
- ✅ **Zero linting errors**
- ✅ **Zero TypeScript errors**
- ✅ **TDD required** (tests before code, always)

## Commands

```bash
# Testing
npm test                      # Run all tests
npm test -- --coverage        # Run tests with coverage report
npm test -- --watch           # Watch mode

# Code Quality
npm run lint                  # Run ESLint
npx prettier --check .        # Check formatting
npx tsc --noEmit             # Type check

# Build
npm run build                 # Compile TypeScript to dist/

# Development
npm run dev                   # Start development server
```

## Architecture Validation

This configuration enforces Clean Architecture with these rules:

- **Domain** → No dependencies
- **Application** → Domain only
- **Infrastructure** → Application + Domain
- **Presentation** → Application + Domain (NOT Infrastructure)
- **DI** → All layers (wires everything together)

Violations are detected automatically before commits.

## Usage with AI Workflow System

1. Copy `config.yml` to your project's `.workflow/` directory
2. Adjust layer paths if needed
3. Tell your AI assistant: "Please read .workflow/playbooks/coordinator.md"
4. Start implementing features using the workflow system

## Example Session

```
User: "implement user registration endpoint"

AI:
🎯 Workflow Coordinator
Detected Intent: FEATURE
Routing to: .workflow/playbooks/feature.md

## Step 1: Initialize Task Tracking
Creating .spec/feature-user-registration.md...

## Step 2: TDD Implementation
🔴 RED: Writing test for POST /api/users...
🟢 GREEN: Implementing registration logic...
✅ All 156 tests passing (100% coverage)

## Step 3: Validation
✅ Tests: 156/156 (100%)
✅ Architecture: Zero violations
✅ Linting: No issues

## Step 4: Commit
✅ Commit: abc1234

✅ Feature Complete: User Registration Endpoint
```

## Notes

- This configuration requires 100% test coverage (configurable)
- TDD is mandatory (can be disabled if needed)
- Architecture validation runs before every commit
- All quality checks must pass before committing

For more information, see the main [AI Workflow System README](../../README.md).
