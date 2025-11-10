# Universal AI Agent Instructions

**Complete instructions for ANY AI assistant (ChatGPT, Gemini, Codex, Claude, Cursor, etc.)**

> This file contains the full workflow system documentation for universal AI tools.
> For Claude Code-specific optimizations, see CLAUDE_INSTRUCTIONS.md

---

## Project: 

**Language**: 
**Framework**: 
**Test Framework**: 
**Architecture**: Clean Architecture (Uncle Bob's principles)

---

## Workflow System

This project uses a **language-agnostic markdown playbook system** in `.workflow/`.

All workflows are:
- ✅ **Tool-agnostic** - Work with any AI assistant
- ✅ **Language-agnostic** - Adapted to  conventions
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
  Understanding  authentication patterns...
  ✅ Exploration complete

  ## Step 3: TDD Implementation

  🔴 RED Phase:
  Writing failing test: "user.test"
  Test: "should generate valid JWT token when credentials valid"
  Running: 
  Result: FAILED ✅ (Expected - test written first)

  🟢 GREEN Phase:
  Implementing: getUser()
  Running: 
  Result: ALL TESTS PASSING ✅

  🔵 REFACTOR Phase:
  Checking code quality...
  ✅ No refactoring needed

  ## Step 4: Validation
  Running validators in parallel:
  - Tests:  → 156/156 PASSING ✅
  - Coverage:  → % ✅
  - Linting:  → No issues ✅

  ## Step 5: Completion
  ✅ Feature complete: User authentication with JWT
  Ready to commit!
```

#### Example 2: Fixing a Bug

```
User: "fix null pointer error in getUser"

AI Assistant:
Step 1: Read .workflow/playbooks/coordinator.md
Step 2: Coordinator detects intent = BUGFIX
Step 3: Route to .workflow/playbooks/bugfix.md
Step 4: Execute bugfix.md:

  ## Step 1: Root Cause Analysis
  Analyzing file: /User.
  Issue: Missing null check on line 45

  ## Step 2: Write Failing Test (TDD)
  🔴 RED: Test reproduces bug
  Test: "should handle null input gracefully"
  Running: 
  Result: FAILING ✅ (Reproduces the bug)

  ## Step 3: Fix Bug
  🟢 GREEN: Adding null check
  Running: 
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
  - Tests:  → PASSING ✅
  - Coverage: % → PASSING ✅
  - Linting:  → PASSING ✅
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
Writing test: user.test
Test: "should validate JWT token"
Running: 
Result: FAILED ✅ (Expected - test written first)

🟢 GREEN: Implementing feature...
Writing: /User.
Running: 
Result: ALL TESTS PASSING ✅

## Step 3: Validation
Running 3 validators in parallel...
- Tests:  → PASSING ✅
- Coverage: % → PASSING ✅
- Linting:  → PASSING ✅
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

**Issue**: Codex may pause after each report waiting for confirmation.

**Solution**: After reporting, IMMEDIATELY continue to next action. Do NOT wait for user input.

Pattern:
```
Report → Continue → Report → Continue → Report → Continue
```

NOT:
```
Report → Wait → Report → Wait  ❌ WRONG
```

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

- **Test command**: ``
- **Coverage command**: ``
- **Required coverage**: %
- **Lint command**: ``
- **Build command**: ``
- **TDD required**: 

---

## Quality Standards (Non-Negotiable)

- ✅ **% test coverage** (statements, branches, functions, lines)
- ✅ **Zero architecture violations**
- ✅ **Zero linting errors**
- ✅ **TDD required**: 

---

## Architecture Rules

### Clean Architecture Dependency Rule

**Allowed Dependencies** (all dependencies point INWARD toward Domain):

- **Domain** → Nothing (pure , zero external dependencies)
- **Application** → Domain only
- **Infrastructure** → Application + Domain
- **Presentation** → Application + Domain (NEVER Infrastructure directly)
- **DI Container** → All layers (wires everything together)

### Layer Paths

```

  ↑

  ↑
  →  
                ↑              ↑
                  
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
              # Run all tests
          # Run tests with coverage report

# Code Quality
              # Run linter
            # Check code formatting
