# Feature Workflow Playbook

**Purpose**: Implement new feature with TDD and quality gates.

**When to use**: Adding new functionality, endpoints, or capabilities.

---

## ⚠️ MANDATORY: Read Reporting Guidelines FIRST ⚠️

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

**RULE**: You MUST announce EVERY step to the user. Silent execution = FAILED workflow.

---

## Step 0: Announce Workflow Start

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

Copy and output this message to the user BEFORE doing anything else:

```
🎯 Feature Workflow

Feature: {brief description from user request}

Executing: .workflow/playbooks/feature.md

This workflow will:
1. Initialize task tracking (.spec/ file)
2. Plan implementation with TDD
3. Implement feature (test-first)
4. Validate (tests, architecture, linting)
5. Commit changes

Let's begin...
```

**After outputting the above message, proceed to Prerequisites Check.**

---

## Prerequisites Check

- [ ] User has clearly described the feature
- [ ] You understand what needs to be implemented
- [ ] Project dependencies are installed (`npm install` completed)

If unclear, ask user for clarification before proceeding.

---

## Step 1: Initialize Task Tracking (MANDATORY)

### 1.1 Extract Feature Name

From user request, create a short, kebab-case slug:

Examples:
- "implement health check endpoint" → `health-check-endpoint`
- "add JWT authentication" → `jwt-authentication`
- "user profile CRUD operations" → `user-profile-crud`

### 1.2 Get Next Sequence Number

**Determine the sequence number** for this spec file:

1. Check if `.spec/.sequence` exists:
   - If exists: Read the number from the file
   - If doesn't exist: Start with `001`

2. The sequence number should be 3-digit, zero-padded (e.g., `001`, `002`, `010`, `100`)

3. After reading the sequence number, increment it and save it back to `.spec/.sequence` for the next use

**Example**:
```bash
# Read current sequence (or initialize to 1)
SEQUENCE=$(cat .spec/.sequence 2>/dev/null || echo "1")
# Format as 3-digit zero-padded
SEQ_NUM=$(printf "%03d" $SEQUENCE)
# Increment for next use
echo $((SEQUENCE + 1)) > .spec/.sequence
```

### 1.3 Create .spec/ File

Create: `.spec/{SEQ_NUM}-feature-{slug}.md`

Examples:
- `.spec/001-feature-health-check-endpoint.md`
- `.spec/002-feature-jwt-authentication.md`
- `.spec/015-feature-user-profile-crud.md`

Use template from `.workflow/templates/feature-template.md`

Fill in:
- Feature name (human-readable)
- Overview (what and why)
- Initial task breakdown (will be refined in Step 2)
- Start date

### 1.4 Update .spec/overall-status.md

1. Read `.spec/overall-status.md`
2. Add to "In Progress" section:
   ```markdown
   1. [Feature: {Name}]({SEQ_NUM}-feature-{slug}.md) - 0%
   ```
3. Update statistics (increment "In Progress" count)
4. Add to "Recent Activity" with timestamp

### 1.5 Confirm to User

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

Copy and output this message to the user:

```
✅ Step 1 Complete: Task Tracking Initialized

Created:
- .spec/{SEQ_NUM}-feature-{slug}.md ({total} tasks, 0% complete)

Updated:
- .spec/overall-status.md
- .spec/.sequence (incremented to {next_seq})

Next: Step 2 - Exploration & Planning
```

**After outputting the above message, proceed to Step 2.**

---

## Step 2: Exploration & Planning

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

Copy and output this message to the user:

```
## Step 2: Exploration & Planning

Understanding existing codebase and planning implementation approach...
```

**After outputting the above message, proceed with exploration activities below.**

### 2.1 Explore Existing Code (if needed)

If feature is complex or you're unfamiliar with codebase:

Use Glob/Grep/Read to:
- Find similar existing features
- Understand current architecture
- Identify where new code should go
- Review existing patterns

### 2.2 Plan Implementation

Break down feature into layers (Clean Architecture):

**For each layer, identify what's needed:**

1. **Domain Layer** (`src/domain/`):
   - New entities?
   - New repository interfaces?
   - Updated domain models?

2. **Application Layer** (`src/application/`):
   - New use cases?
   - What operations?

3. **Infrastructure Layer** (`src/infrastructure/`):
   - Repository implementations?
   - External service integrations?

4. **Presentation Layer** (`src/presentation/`):
   - New controllers?
   - New routes?
   - Request/response handling?

5. **DI Layer** (`src/di/`):
   - Dependency wiring?

### 2.3 Update .spec/ File with Detailed Tasks

Update `.spec/{SEQ_NUM}-feature-{slug}.md` with task breakdown:

```markdown
## Tasks

### Research & Planning
- [x] Explore existing codebase structure
- [x] Plan implementation approach

### Domain Layer (TDD)
- [ ] Write entity tests
- [ ] Implement entities
- [ ] Write repository interface tests
- [ ] Define repository interfaces

### Application Layer (TDD)
- [ ] Write use case tests
- [ ] Implement use cases

### Infrastructure Layer (TDD)
- [ ] Write repository implementation tests
- [ ] Implement repositories

### Presentation Layer (TDD)
- [ ] Write controller tests
- [ ] Implement controllers
- [ ] Write route tests
- [ ] Implement routes

### DI Layer
- [ ] Update dependency injection container

### Validation
- [ ] Run test suite (100% coverage required)
- [ ] Run architecture validator
- [ ] Run linting/static analysis

### Total Tasks: {count}
```

---

**Report to user after planning**:
```
✅ Step 2 Complete: Planning

Implementation plan:
- Domain: {what's needed}
- Application: {what's needed}
- Infrastructure: {what's needed}
- Presentation: {what's needed}

Total tasks: {count}

Next: Step 3 - TDD Implementation
```

---

## Step 3: TDD Implementation (MANDATORY)

**Report to user**:
```
## Step 3: TDD Implementation

Following Test-Driven Development (Red-Green-Refactor cycle)

Reading: .workflow/playbooks/tdd.md

I'll report each TDD cycle: 🔴 RED → 🟢 GREEN → 🔵 REFACTOR
```

**CRITICAL**: Read and follow `.workflow/playbooks/tdd.md` for EVERY implementation task.

### 3.1 Work Through Tasks Layer by Layer

**Implement in this order** (respecting dependency flow):

1. **Domain** (pure business logic, no dependencies)
2. **Application** (use cases, depends on domain)
3. **Infrastructure** (concrete implementations)
4. **Presentation** (controllers, routes)
5. **DI** (wire everything together)

### 3.2 For EACH Task in Layer

**Follow TDD playbook exactly:**

1. Read `.workflow/playbooks/tdd.md`
2. Execute Red-Green-Refactor cycle:
   - RED: Write failing test
   - GREEN: Write minimal implementation
   - REFACTOR: Improve code (optional)
3. Mark task complete in `.spec/{SEQ_NUM}-feature-{slug}.md`
4. Update progress percentage
5. Move to next task

**DO NOT skip TDD playbook.** Tests MUST be written before implementation.

### 3.3 Track Progress

After completing each task:

1. Update `.spec/{SEQ_NUM}-feature-{slug}.md`:
   - Mark task complete: `- [x]`
   - Update completion percentage
   - Add notes if needed

2. **Report progress to user** (after EVERY task or every 3-5 tasks):

**Progress Update Template**:
```
📊 Progress Update

Feature: {name}
Completed: {X}/{total} tasks ({percentage}%)
Current layer: {Domain|Application|Infrastructure|Presentation}

Recent completions:
✅ {task 1}
✅ {task 2}
🔄 {current task}

Tests: {passing}/{total} passing ({coverage}%)
```

Example progress update:
```
📊 Progress Update

Feature: {name}
Completed: {X}/{total} tasks ({percentage}%)
Current: {current task name}
Tests: {passing}/{total} passing
```

---

**Report before validation**:
```
✅ Step 3 Complete: TDD Implementation

All tasks complete: {total}/{total} (100%)
Tests: {passing}/{passing} passing
Coverage: {coverage}%

Next: Step 4 - Validation (Running 3 validators)
```

---

## Step 4: Validation (MANDATORY)

**Report to user**:
```
## Step 4: Validation

Running 3 validators in parallel:
1. 🧪 Test Suite (coverage check)
2. 🏛️ Architecture Validator
3. 🔍 Static Analysis / Linting

Please wait...
```

All THREE validators must pass before proceeding.

### 4.1 Run Full Test Suite

```bash
npm test -- --coverage
```

**Requirements**:
- [ ] All tests passing
- [ ] Coverage = 100% (statements, branches, functions, lines)

**If fails**:
- Identify failing tests
- Fix implementation or tests
- Re-run until all pass

### 4.2 Run Architecture Validator

Read and follow `.workflow/playbooks/architecture-check.md`

**Requirements**:
- [ ] Zero architecture violations
- [ ] All dependencies point inward only
- [ ] No layer violations

**If fails**:
- Review violations
- Move code to correct layer
- Fix dependency directions
- Re-run until compliant

### 4.3 Run Linting

```bash
npm run lint
```

**Requirements**:
- [ ] Zero linting errors
- [ ] Zero TypeScript errors
- [ ] Code follows style guidelines

**If fails**:
- Fix linting issues
- Fix type errors
- Re-run until clean

### 4.4 Confirm Validation

**Report to user**:
```
✅ Step 4 Complete: Validation

Validation Results:
✅ Tests: {passing}/{total} ({coverage}%)
✅ Architecture: Zero violations
✅ Linting: No issues

All validators PASSED ✅

Feature implementation complete!

Next: Step 5 - Finalization & Commit
```

---

## Step 5: Finalization

### 5.1 Update .spec/ Files

Update `.spec/{SEQ_NUM}-feature-{slug}.md`:
1. Mark all remaining tasks complete
2. Set Status to "Completed"
3. Add completion date
4. Update progress to 100%
5. Add final notes/summary

### 5.2 Commit Changes

Execute `.workflow/playbooks/commit.md` to:
- Update overall-status.md
- Run validators (again, in parallel)
- Create git commit
- Report summary

---

## Step 6: Report to User

```
✅ Feature Complete: {Feature Name}

Implementation Summary:
- Tasks completed: {X}/{X} (100%)
- Tests added: {count} (all passing)
- Coverage: {coverage}%
- Architecture: Compliant ✅
- Linting: Clean ✅
- Commit: {hash}

Files changed:
{List of modified files}

Layer breakdown:
- Domain: {files modified}
- Application: {files modified}
- Infrastructure: {files modified}
- Presentation: {files modified}
- DI: {files modified}

Next steps:
- Feature is ready for review
- All quality gates passed
- .spec/ files updated and committed
```

---

## Checklist for AI Assistants

Before marking this playbook complete, verify:

- [ ] Step 1: Task tracking initialized (.spec/{SEQ_NUM}-feature-*.md created with sequence number)
- [ ] Step 1: overall-status.md updated
- [ ] Step 2: Implementation plan created with task breakdown
- [ ] Step 3: TDD playbook followed for ALL implementation
- [ ] Step 3: Tests written BEFORE implementation (every time)
- [ ] Step 3: All tasks marked complete in .spec/ file
- [ ] Step 4: All three validators passed (tests, architecture, linting)
- [ ] Step 5: Commit playbook executed successfully
- [ ] Step 6: Reported comprehensive summary to user

If ANY checkbox is unchecked, playbook is NOT complete.

---

## Notes

- **Never skip TDD playbook** - tests must come first, always
- **Update .spec/ files frequently** - after each task or small batch
- **Validate early and often** - don't wait until the end
- **Ask user for clarification** - if requirements unclear
- **Keep commits atomic** - can commit after each layer if desired
- **Report progress regularly** - keeps user informed

---

## Error Recovery

### If tests fail during implementation:
1. Review test failure messages
2. Debug implementation
3. Fix issues
4. Re-run tests
5. Continue when green

### If architecture validation fails:
1. Review violations
2. Understand which layer is wrong
3. Move code to correct layer
4. Update imports
5. Re-validate

### If unclear about requirements:
1. STOP implementation
2. Ask user specific questions
3. Wait for clarification
4. Resume with clear understanding
