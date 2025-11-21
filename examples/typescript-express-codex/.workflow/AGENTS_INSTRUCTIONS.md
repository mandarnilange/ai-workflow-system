# Universal AI Agent Instructions

**Complete instructions for ANY AI assistant (ChatGPT, Gemini, Codex, Claude, Cursor, etc.)**

> This file contains the full workflow system documentation for universal AI tools.
> For Claude Code-specific optimizations, see CLAUDE_INSTRUCTIONS.md

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

## Project: Codex Sample Project

**Language**: TypeScript
**Framework**: Express.js
**Test Framework**: Jest
**Architecture**: Clean Architecture (Uncle Bob's principles)

---

## Core Philosophy (XP Principles)

This project follows **Extreme Programming (XP)** values. Every agent must embody these principles:

1.  **Simplicity**: Do the simplest thing that could possibly work. Avoid over-engineering. YAGNI (You Ain't Gonna Need It).
2.  **Feedback**: Shorten feedback loops. Run tests frequently.
3.  **Courage**: Refactor mercilessly. If code smells, fix it immediately. Don't be afraid to delete dead code.
4.  **Respect**: Leave the code better than you found it. Write clean, readable, self-documenting code.

---

## Workflow System

This project uses a **language-agnostic markdown playbook system** in `.workflow/`.

All workflows are:
- ✅ **Tool-agnostic** - Work with any AI assistant
- ✅ **Language-agnostic** - Adapted to TypeScript conventions
- ✅ **Human-readable** - Developers can follow them manually
- ✅ **Version-controlled** - Tracked in git for team consistency

---

## Quick Start Guide

### Step 1: Understand the Coordinator

For **ANY** implementation work (features, bugs, refactors), always start here:

**Read and execute**: `.workflow/playbooks/coordinator.md`

The coordinator playbook will:
1. ✅ Detect your intent (feature, bug fix, refactor, commit)
2. ✅ Route you to the appropriate specialized playbook
3. ✅ Guide you step-by-step through the TDD process
4. ✅ Ensure all quality gates pass

### Step 2: Example Workflow Usage

#### Example 1: Implementing a Feature

```
User: "implement user authentication with JWT"

AI Assistant:
Step 1: Read .workflow/playbooks/coordinator.md
Step 2: Coordinator detects intent = FEATURE
Step 3: Route to .workflow/playbooks/feature.md
Step 4: Execute feature.md step-by-step:

  ## Step 1: Task Tracking
  Creating .spec/feature-user-authentication-jwt.md...
  ✅ Task tracking initialized

  ## Step 2: Exploration
  Reading existing auth code...
  Understanding Express.js authentication patterns...
  ✅ Exploration complete

  ## Step 3: TDD Implementation

  🔴 RED Phase:
  Writing failing test: "User.test.ts"
  Test: "should generate valid JWT token when credentials valid"
  Running: npm test
  Result: FAILED ✅ (Expected - test written first)

  🟢 GREEN Phase:
  Implementing: getUserById()
  Running: npm test
  Result: ALL TESTS PASSING ✅

  🔵 REFACTOR Phase:
  Checking code quality...
  ✅ No refactoring needed

  ## Step 4: Validation
  Running validators in parallel:
  - Tests: npm test → 156/156 PASSING ✅
  - Coverage: npm test -- --coverage → 100% ✅
  - Linting: npm run lint → No issues ✅

  ## Step 5: Completion
  ✅ Feature complete: User authentication with JWT
  Ready to commit!
```

#### Example 2: Fixing a Bug

```
User: "fix null pointer error in getUserById"

AI Assistant:
Step 1: Read .workflow/playbooks/coordinator.md
Step 2: Coordinator detects intent = BUGFIX
Step 3: Route to .workflow/playbooks/bugfix.md
Step 4: Execute bugfix.md:

  ## Step 1: Root Cause Analysis
  Analyzing file: src/domain/User.ts
  Issue: Missing null check on line 45

  ## Step 2: Write Failing Test (TDD)
  🔴 RED: Test reproduces bug
  Test: "should handle null input gracefully"
  Running: npm test
  Result: FAILING ✅ (Reproduces the bug)

  ## Step 3: Fix Bug
  🟢 GREEN: Adding null check
  Running: npm test
  Result: ALL TESTS PASSING ✅

  ## Step 4: Validation
  ✅ All validators passed

  ✅ Bug fixed!
```

#### Example 3: Committing Changes

```
User: "commit these changes"

AI Assistant:
Step 1: Read .workflow/playbooks/commit.md
Step 2: Execute commit.md:

  ## Step 1: Update Task Tracking
  Updating .spec/feature-xyz.md
  Progress: 8/9 tasks (89%)
  ✅ Tracking updated

  ## Step 2: Run All Validators
  Running validators in parallel:
  - Tests: npm test → PASSING ✅
  - Coverage: 100% → PASSING ✅
  - Linting: npm run lint → PASSING ✅
  - Architecture: Clean Architecture check → PASSING ✅

  ## Step 3: Git Commit
  Type: feat
  Message: add user authentication with JWT tokens
  Commit: abc1234
  ✅ Committed successfully
```

---

## How to Use This Workflow System

### For Implementation Work
When the user asks you to implement a feature, fix a bug, or refactor code:

1. **Read**: `.workflow/playbooks/coordinator.md`
2. **Execute**: Follow the coordinator's instructions step-by-step
3. **Report**: Announce every action BEFORE you take it

### For Commits
When the user asks you to commit changes:

1. **Read**: `.workflow/playbooks/commit.md`
2. **Execute**: Run all validators
3. **Commit**: Only if all validators pass

---

## ⚠️ CRITICAL: User Visibility Requirements ⚠️

**MANDATORY for ALL AI assistants**:

Before executing ANY playbook, read: **`.workflow/playbooks/reporting-guidelines.md`**

### THIS IS NOT OPTIONAL

**RULE**: Every action you take MUST be announced to the user BEFORE you take it.

**Silent execution = FAILED workflow.**

If you execute code, create files, run tests, or make ANY change without first announcing it, you have FAILED.

### Why This Matters

Users MUST see what you're doing in real-time. Silent execution is unacceptable.

**You MUST announce BEFORE doing each action**:
- 🎯 Which workflow/playbook you're executing
- 🔢 Which step you're on (Step 1, Step 2, etc.)
- 🔴 TDD phases (RED → GREEN → REFACTOR)
- ✅ Validation results (tests, linting, architecture)
- 📊 Progress updates throughout execution

**Format**: When playbook says **"Report to user:"** → Output that message to user IMMEDIATELY

### Examples of Good vs Bad Reporting

**✅ GOOD - Announces before executing**:
```
🎯 Feature Workflow: User Authentication

Executing: .workflow/playbooks/feature.md

## Step 1: Initialize Task Tracking
Creating .spec/feature-user-authentication.md...
✅ Task tracking initialized

## Step 2: TDD Implementation
🔴 RED: Writing failing test...
Writing test: User.test.ts
Test: "should validate JWT token"
Running: npm test
Result: FAILED ✅ (Expected - test written first)

🟢 GREEN: Implementing feature...
Writing: src/domain/User.ts
Running: npm test
Result: ALL TESTS PASSING ✅

## Step 3: Validation
Running 3 validators in parallel...
- Tests: npm test → PASSING ✅
- Coverage: 100% → PASSING ✅
- Linting: npm run lint → PASSING ✅
✅ All validators passed
```

**❌ BAD - Silent execution**:
```
[AI silently creates files, writes code, runs tests]
AI: "Done. Feature implemented. Commit abc1234"
```

**Enforcement**: Every playbook includes "Report to user:" blocks at each step that you MUST output.

---

## 🤖 AI-Specific Guidance

### For Google Gemini

**Issue**: Gemini sometimes executes actions without announcing them first.

**Solution**: Follow these rules strictly:

1. **Before EVERY file operation** (Read, Write, Edit):
   - Output: "Reading {file}" or "Writing {file}" or "Editing {file}"
   - THEN execute the operation

2. **Before EVERY command** (bash, npm, git):
   - Output: "Running: {command}"
   - THEN execute the command

3. **Before EVERY step** in playbook:
   - Output: "## Step {number}: {name}"
   - THEN execute the step

4. **After EVERY step** in playbook:
   - Output: "✅ Step {number} Complete"
   - THEN continue to next step

**Self-check question**: "Did I announce this action to the user BEFORE doing it?"
- If NO → STOP and announce it first
- If YES → Proceed

**Pattern to follow**:
```
ANNOUNCE → EXECUTE → REPORT RESULT → ANNOUNCE NEXT → EXECUTE → REPORT RESULT → ...
```

**NOT**:
```
EXECUTE → EXECUTE → EXECUTE → "Done"  ❌ WRONG
```

### For ChatGPT / GPT-4

Follow reporting-guidelines.md exactly. When you see "Report to user:", output that message.

### For Codex

**CRITICAL ISSUE**: Codex has a tendency to pause after each report waiting for user confirmation. **DO NOT DO THIS.**

**YOU MUST**: Execute workflows CONTINUOUSLY without pausing between steps.

**Execution Pattern (MANDATORY)**:
```
Report Step 1 → IMMEDIATELY Execute Step 2 → Report Step 2 → IMMEDIATELY Execute Step 3 → Continue until complete
```

**NEVER DO THIS**:
```
Report Step 1 → PAUSE and wait for user → ❌ WRONG - DO NOT WAIT
```

**Rules for Codex**:
1. After reporting a step completion, IMMEDIATELY start the next step
2. Do NOT wait for user to say "continue" or "proceed"
3. Do NOT ask "Should I continue?" or "Ready for next step?"
4. Execute the ENTIRE playbook in ONE continuous session
5. Only stop if: (a) Playbook explicitly says to stop, (b) User interrupts, or (c) Error occurs

**Self-check**: Before pausing, ask yourself "Did the playbook tell me to stop here?" If NO, then CONTINUE IMMEDIATELY.

### For Claude Code

Claude Code has native support for these workflows. Follow playbooks as written.

### For Cursor / Copilot

These tools work in IDE context. Suggest commands to user when needed, but always announce what you're doing.

---

## Quick Reference

| User Request | Playbook to Read |
|--------------|------------------|
| "implement X", "add Y", "create Z" | `.workflow/playbooks/coordinator.md` |
| "fix bug X", "error in Y" | `.workflow/playbooks/coordinator.md` |
| "refactor X", "clean up Y" | `.workflow/playbooks/coordinator.md` |
| "commit", "save changes" | `.workflow/playbooks/commit.md` |

---

## Available Playbooks

Located in `.workflow/playbooks/`:

1. **coordinator.md** - Master router (start here for implementation work)
2. **feature.md** - Feature implementation with TDD
3. **bugfix.md** - Bug fix workflow with TDD
4. **commit.md** - Pre-commit validation and git commit
5. **tdd.md** - Test-Driven Development cycle (Red-Green-Refactor)
6. **architecture-check.md** - Clean Architecture validation
7. **reporting-guidelines.md** - Reporting requirements (READ THIS FIRST!)

**Complete documentation**: `.workflow/README.md`

---

## Project Configuration

All project-specific settings are in `.workflow/config.yml`:

- **Test command**: `npm test`
- **Coverage command**: `npm test -- --coverage`
- **Required coverage**: 100%
- **Lint command**: `npm run lint`
- **Build command**: `npm run build`
- **TDD required**: true

---

## Quality Standards (Non-Negotiable)

- ✅ **100% test coverage** (statements, branches, functions, lines)
- ✅ **Zero architecture violations**
- ✅ **Zero linting errors**
- ✅ **TDD required**: true

---

## Architecture Rules

### Clean Architecture Dependency Rule

**Allowed Dependencies** (all dependencies point INWARD toward Domain):

- **Domain** → Nothing (pure TypeScript, zero external dependencies)
- **Application** → Domain only
- **Infrastructure** → Application + Domain
- **Presentation** → Application + Domain (NEVER Infrastructure directly)
- **DI Container** → All layers (wires everything together)

### Layer Paths

```
src/domain
  ↑
src/application
  ↑
src/infrastructure  →  src/presentation
                ↑              ↑
                  src/di
```

**CRITICAL**: Presentation layer must NEVER import from Infrastructure. Use dependency injection.

---

## Git Commit Standards

### Conventional Commits Format

```
<type>: <subject>

<optional body>
```

### Commit Types
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code refactoring (no behavior change)
- `test` - Adding or updating tests
- `docs` - Documentation changes
- `chore` - Maintenance tasks

### Commit Rules
- **Subject**: imperative mood, lowercase, no period, <50 chars
- **Body**: explain WHY (not WHAT), optional, <72 chars per line
- **No AI attribution**: Do not add "Co-Authored-By: AI" or similar
- **No emoji**: Unless explicitly requested by user

### Examples

```bash
# Good commits
feat: add jwt authentication for users
fix: handle null email in user validation
refactor: extract auth logic to domain layer

# Bad commits
feat: Added new feature  # Wrong tense
fix.  # Missing description
feat: add stuff  # Too vague
```

---

## Common Commands

```bash
# Testing
npm test              # Run all tests
npm test -- --coverage          # Run tests with coverage report

# Code Quality
npm run lint              # Run linter
npx prettier --check .            # Check code formatting
npx tsc --noEmit        # Run type checker

# Build
npm run build             # Build the project
```

---

## Validation Checklist

Before EVERY commit, ALL of these must pass:

- [ ] **Tests**: All tests passing (`npm test`)
- [ ] **Coverage**: 100% coverage achieved (`npm test -- --coverage`)
- [ ] **Linting**: Zero linting errors (`npm run lint`)
- [ ] **Type Checking**: Zero type errors (`npx tsc --noEmit`)
- [ ] **Architecture**: Zero dependency violations
- [ ] **.spec/ files**: Task tracking files updated and accurate

**No exceptions**. If any validator fails, you MUST fix it before committing.

---

## Code Quality Standards

### TypeScript Conventions

- **Functions**: camelCase (e.g., `getUserById`)
- **Variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE
- **Classes**: PascalCase (e.g., `User`)
- **Files**: PascalCase

### Testing Standards

- **Framework**: Jest
- **Test Location**: tests/
- **Test Pattern**: *.test.ts
- **Coverage Target**: 100%
- **TDD Required**: true
- **Edge Cases**: MUST be identified and tested (nulls, empty strings, boundaries, invalid inputs)

### Test Naming

Use descriptive test names:
```
should [expected behavior] when [condition]
```

Examples:
```typescript
describe('User', () => {
  it('should return user when valid id provided', () => {
    // Arrange-Act-Assert
  })

  it('should throw error when user not found', () => {
    // Arrange-Act-Assert
  })
})
```

---

## Task Tracking

All work must be tracked in `.spec/` directory:

- **Features**: `.spec/feature-{name}.md`
- **Bugs**: `.spec/fix-{name}.md`
- **Refactoring**: `.spec/refactor-{name}.md`
- **Dashboard**: `.spec/overall-status.md`

Templates are available in `.workflow/templates/`.

---

## Summary

**This project enforces quality through automated workflows**:

✅ **Test-Driven Development (TDD)** - Tests before code, always
✅ **Clean Architecture** - Strict dependency rules enforced
✅ **100% Test Coverage** - No compromises
✅ **Comprehensive Tracking** - All work tracked in .spec/
✅ **Validated Commits** - All quality gates must pass

**All workflows are in `.workflow/playbooks/` - just read and follow them!**

---

## For Manual Execution (Humans)

These playbooks work for human developers too:
1. Read the appropriate playbook from `.workflow/playbooks/`
2. Follow the steps manually
3. Run the commands in your terminal
4. Check off each completed step

The playbooks are human-readable documentation and can be followed without AI assistance.

---

## Need Help?

- Read `.workflow/README.md` for comprehensive documentation
- Check `.workflow/config.yml` for project-specific settings
- Each playbook includes detailed step-by-step instructions
- When in doubt, ask the user for clarification

---

**Remember**: Always follow the playbooks. They contain all workflow logic.
