# Claude Code Instructions

**Complete instructions for Claude Code with optimizations**

---

## ⚠️ CRITICAL: MANDATORY WORKFLOW SYSTEM ⚠️

**This project requires STRICT adherence to the workflow playbooks.**

### ❌ FORBIDDEN
- Starting code implementation directly
- Skipping playbook execution
- Writing code before reading coordinator.md
- Silent execution without reporting

### ✅ MANDATORY
- Read `.workflow/playbooks/coordinator.md` FIRST for ANY implementation work
- Follow playbook instructions step-by-step (CONTINUOUSLY - do not pause between steps)
- Announce each step BEFORE executing it
- Report progress throughout execution
- **CRITICAL**: Execute all steps CONTINUOUSLY without waiting for user confirmation

**Direct implementation without workflow = FAILURE**

### 📝 Execution Pattern (IMPORTANT)

**CORRECT execution pattern** (continuous):
```
Read playbook → Execute Step 1 → Report result → Execute Step 2 → Report result → Execute Step 3 → Report result → Complete
```

**WRONG execution pattern** (waiting):
```
Read playbook → Execute Step 1 → Report result → WAIT FOR USER ❌
```

**DO NOT PAUSE** between steps. Execute the entire workflow continuously unless the playbook explicitly says to stop or the user interrupts.

---

## Workflow System

This project uses a **generic markdown playbook system** in `.workflow/`.

All workflows are documented in playbooks that work with any AI assistant.

---

## For ANY Implementation Work

Read and execute: **`.workflow/playbooks/coordinator.md`**

The coordinator will detect intent and route you to the appropriate workflow.

---

## Quick Reference

| User Request | Playbook to Execute |
|--------------|---------------------|
| "implement X" | `.workflow/playbooks/coordinator.md` |
| "add feature Y" | `.workflow/playbooks/coordinator.md` |
| "fix bug Z" | `.workflow/playbooks/coordinator.md` |
| "refactor W" | `.workflow/playbooks/coordinator.md` |
| "commit changes" | `.workflow/playbooks/commit.md` |

---

## Playbook System

All playbooks are in `.workflow/playbooks/`:

- **coordinator.md** - Master router (detects intent, routes to appropriate workflow)
- **feature.md** - Feature implementation workflow with TDD
- **bugfix.md** - Bug fix workflow with TDD
- **commit.md** - Pre-commit validation and git commit
- **tdd.md** - Test-Driven Development cycle (Red-Green-Refactor)
- **architecture-check.md** - Clean Architecture validation
- **reporting-guidelines.md** - User visibility requirements (READ FIRST!)

**Read `.workflow/README.md` for complete documentation.**

---

## Project Context

**Tech Stack**:
- Language: TypeScript
- Framework: Express.js
- Testing: Jest

**Architecture**: Clean Architecture (Uncle Bob's principles)
- src/domain → src/application → src/infrastructure → src/presentation → src/di

**Quality Standards** (Non-Negotiable):
- 100% test coverage (statements, branches, functions, lines)
- Zero architecture violations
- Zero linting errors
- TDD required: true

---

## Code Quality Standards

### TypeScript

- Functions: camelCase
- Variables: camelCase
- Constants: UPPER_SNAKE_CASE
- Class files: PascalCase

### Testing

- Framework: Jest
- Test directory: tests/
- Test pattern: *.test.ts
- Coverage: 100%
- TDD: true

### Naming Conventions

- Classes: PascalCase
- Functions: camelCase
- Use cases: VerbNoun pattern
- Test descriptions: "should [expected behavior] when [condition]"

---

## Architecture Rules

**Dependency Rule** (dependencies point inward only):
- Domain → Nothing (pure TypeScript)
- Application → Domain only
- Infrastructure → Application + Domain
- Presentation → Application + Domain (never Infrastructure directly)
- DI Container → All layers (wires everything together)

---

## Git Commit Standards

**Format**:
```
<type>: <subject>

<optional body>
```

**Types**: feat, fix, refactor, test, docs, chore

**Rules**:
- Subject: imperative mood, lowercase, no period, <50 chars
- Body: explain WHY (not WHAT), optional

---

## Common Commands

```bash
npm test              # Run tests
npm test -- --coverage          # Coverage report
npm run lint              # Run linter

# Build
npm run build             # Build the project
```

---

## Important Notes

1. **Always use playbooks** - Don't manually orchestrate workflows
2. **TDD is mandatory** - Tests before code (if configured: true)
3. **100% coverage required** - No compromises
4. **Architecture compliance** - Validated before every commit
5. **Task tracking** - .spec/ files must be updated (if enabled: true)

---


## Examples

### Example 1: User wants to add a feature
```
User: "implement health check endpoint"

Claude:
1. Read .workflow/playbooks/coordinator.md
2. Coordinator detects intent: FEATURE
3. Routes to .workflow/playbooks/feature.md
4. Follow feature.md step-by-step
5. Report completion
```

### Example 2: User wants to commit
```
User: "commit these changes"

Claude:
1. Read .workflow/playbooks/commit.md
2. Follow commit.md step-by-step:
   - Update .spec/ files
   - Run validators (tests, linting, architecture)
   - Create git commit
   - Report summary
```

### Example 3: User reports a bug
```
User: "fix crash when email is null"

Claude:
1. Read .workflow/playbooks/coordinator.md
2. Coordinator detects intent: BUGFIX
3. Routes to .workflow/playbooks/bugfix.md
4. Follow bugfix.md step-by-step
5. Report completion
```

---

## For More Information

See complete documentation:
- `.workflow/README.md` - Overview and philosophy
- `.workflow/config.yml` - Project configuration
- `.workflow/playbooks/*.md` - All workflow playbooks
- `.workflow/templates/*.md` - Templates for .spec/ files

---

**That's it. The playbooks contain all workflow logic. Just read and follow them.**
