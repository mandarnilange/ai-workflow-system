# Claude Code Instructions

**Complete instructions for Claude Code with optimizations**

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
- Language: 
- Framework: 
- Testing: 

**Architecture**: Clean Architecture (Uncle Bob's principles)
-  →  →  →  → 

**Quality Standards** (Non-Negotiable):
- % test coverage (statements, branches, functions, lines)
- Zero architecture violations
- Zero linting errors
- TDD required: 

---

## Code Quality Standards

### 

- Functions: 
- Variables: 
- Constants: 
- Class files: 

### Testing

- Framework: 
- Test directory: 
- Test pattern: 
- Coverage: %
- TDD: 

### Naming Conventions

- Classes: PascalCase
- Functions: 
- Use cases:  pattern
- Test descriptions: "should [expected behavior] when [condition]"

---

## Architecture Rules

**Dependency Rule** (dependencies point inward only):
- Domain → Nothing (pure )
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
              # Run tests
          # Coverage report
              # Run linter

```

---

## Important Notes

1. **Always use playbooks** - Don't manually orchestrate workflows
2. **TDD is mandatory** - Tests before code (if configured: )
3. **% coverage required** - No compromises
4. **Architecture compliance** - Validated before every commit
5. **Task tracking** - .spec/ files must be updated (if enabled: )

---

## ⚡ Claude Code Optimizations

### Parallel Execution

**CRITICAL**: Maximize performance by running independent operations in parallel.

**Pattern**: Call multiple tools in a SINGLE message whenever possible.

#### Example: Running Validators (commit.md Step 2)

**✅ CORRECT - Parallel (FAST)**:
```
Send ONE message with THREE Bash tool calls:
1. Bash: npm test -- --coverage
2. Bash: npm run lint
3. Bash: npx tsc --noEmit
(All run concurrently)
```

**❌ WRONG - Sequential (SLOW)**:
```
Message 1: Bash: npm test -- --coverage (wait for response)
Message 2: Bash: npm run lint (wait for response)
Message 3: Bash: npx tsc --noEmit (wait for response)
(3x slower due to round trips)
```

#### Example: Reading Multiple Files

**✅ CORRECT - Parallel**:
```
Send ONE message with multiple Read tool calls:
- Read: src/domain/User.ts
- Read: src/application/GetUsers.ts
- Read: tests/domain/User.test.ts
(All read concurrently)
```

**❌ WRONG - Sequential**:
```
Read one file → wait → Read next file → wait → Read next file
```

#### When to Use Parallel Execution

1. **Validators** (commit.md Step 2) - Run tests, linting, architecture check in parallel
2. **File reads** - Reading multiple unrelated files
3. **Git operations** - `git status`, `git diff`, `git log` can run together
4. **Independent searches** - Multiple Glob/Grep operations

#### When NOT to Use Parallel

1. **Dependencies** - If operation B needs result from operation A
2. **File writes** - Write operations that might conflict
3. **Sequential logic** - When order matters

### Use Task Tool for Complex Searches

When searching for code or exploring codebase:

**✅ Use Task tool with Explore agent**:
```
User: "Where are errors from the client handled?"
Assistant: [Uses Task tool with subagent_type=Explore]
```

**❌ Don't run Grep directly** for open-ended searches:
```
❌ Grep for "error" → Grep for "client" → Read files → Grep again
(Too many round trips)
```

### Run Tests with Coverage in ONE Command

**✅ CORRECT**:
```bash
${COVERAGE_COMMAND}              # Single command gets both tests + coverage
```

**❌ WRONG**:
```bash
npm test                       # Run tests
npm test -- --coverage         # Run again for coverage (wasteful)
```

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
