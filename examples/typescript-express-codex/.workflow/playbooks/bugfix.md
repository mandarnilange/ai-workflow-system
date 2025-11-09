# Bugfix Workflow Playbook

**Purpose**: Fix bugs with TDD approach (test to reproduce, then fix).

**When to use**: Fixing broken functionality, crashes, errors, or unexpected behavior.

---

## IMPORTANT: Read Reporting Guidelines FIRST

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

You MUST announce each step and report progress to keep the user informed.

---

## Step 0: Announce Workflow Start

**Report to user**:
```
🎯 Bugfix Workflow

Bug: {brief description from user request}

Executing: .workflow/playbooks/bugfix.md

This workflow will:
1. Initialize bug tracking (.spec/ file)
2. Investigate and identify root cause
3. Write failing test to reproduce bug (TDD)
4. Fix bug with minimal changes
5. Validate (tests, architecture, linting)
6. Commit changes

Let's begin...
```

---

## Prerequisites Check

- [ ] User has described the bug clearly
- [ ] You understand what's broken and expected behavior
- [ ] You can reproduce the issue (or user provided reproduction steps)

If unclear, ask user for clarification before proceeding.

---

## Step 1: Initialize Task Tracking (MANDATORY)

### 1.1 Extract Bug Name

From user request, create a short, kebab-case slug:

Examples:
- "fix crash when email is null" → `crash-null-email`
- "fix incorrect total calculation" → `incorrect-total-calculation`
- "fix API 500 error on GET /users" → `api-500-get-users`

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

Create: `.spec/{SEQ_NUM}-fix-{slug}.md`

Examples:
- `.spec/001-fix-crash-null-email.md`
- `.spec/002-fix-incorrect-total-calculation.md`
- `.spec/015-fix-api-500-get-users.md`

Use template from `.workflow/templates/bugfix-template.md`

Fill in:
- Bug description
- Expected vs actual behavior
- Reproduction steps (if available)
- Affected components
- Start date

### 1.4 Update .spec/overall-status.md

1. Read `.spec/overall-status.md`
2. Add to "In Progress" section:
   ```markdown
   1. [Fix: {Bug Name}]({SEQ_NUM}-fix-{slug}.md) - 0%
   ```
3. Update statistics
4. Add to "Recent Activity" with timestamp

### 1.5 Confirm to User

**Report to user**:
```
✅ Step 1 Complete: Bug Tracking Initialized

Created:
- .spec/{SEQ_NUM}-fix-{slug}.md ({total} tasks, 0% complete)

Updated:
- .spec/overall-status.md
- .spec/.sequence (incremented to {next_seq})

Next: Step 2 - Investigation & Root Cause Analysis
```

---

## Step 2: Investigation & Root Cause Analysis

**Report to user**:
```
## Step 2: Investigation & Root Cause Analysis

Locating affected code and identifying root cause...
```

### 2.1 Locate Affected Code

Use Grep/Glob/Read to:
- Find the code related to bug
- Identify the module/component with issue
- Review existing tests (if any)
- Check git history (`git log`, `git blame`) for context

### 2.2 Reproduce the Bug

**If user provided reproduction steps:**
- Follow the steps
- Verify you can reproduce the issue
- Document exact behavior

**If no reproduction steps:**
- Analyze the bug description
- Create minimal test case
- Reproduce the issue
- Document reproduction steps in .spec/ file

### 2.3 Identify Root Cause

Analyze the code to understand:
- Why is the bug happening?
- What assumption was wrong?
- What edge case wasn't handled?
- Is this a logic error, type error, or missing validation?

Document findings in `.spec/{SEQ_NUM}-fix-{slug}.md`:
```markdown
## Root Cause Analysis

**Cause**: {What's causing the bug}
**Location**: {File and line number}
**Reason**: {Why it happens}
```

### 2.4 Update .spec/ File with Tasks

```markdown
## Tasks

### Investigation
- [x] Locate affected code
- [x] Reproduce bug
- [x] Identify root cause

### Test Creation (TDD)
- [ ] Write failing test that reproduces bug
- [ ] Verify test fails for correct reason

### Implementation
- [ ] Fix the bug with minimal changes
- [ ] Verify fix passes new test
- [ ] Verify no regressions (all tests pass)

### Validation
- [ ] Run full test suite (100% coverage)
- [ ] Run architecture validator
- [ ] Run linting
- [ ] Manual verification (if applicable)

### Total Tasks: {count}
```

**Report to user after investigation**:
```
✅ Step 2 Complete: Root Cause Identified

Root Cause:
- File: {file path}:{line number}
- Issue: {what's causing the bug}
- Reason: {why it happens}

Next: Step 3 - Write Failing Test (TDD)
```

---

## Step 3: Write Failing Test (TDD - MANDATORY)

**Report to user**:
```
## Step 3: Write Failing Test (TDD)

Following Test-Driven Development to reproduce bug before fixing...

Reading: .workflow/playbooks/tdd.md
```

**CRITICAL**: Write test BEFORE fixing the bug.

### 3.1 Create Test that Reproduces Bug

Following TDD playbook (`.workflow/playbooks/tdd.md`):

1. Identify which test file to update:
   - If existing test file: Add test case
   - If no test file: Create new test file

2. Write test that demonstrates the bug:
   ```typescript
   it('should {expected behavior} when {bug condition}', () => {
     // Arrange: Set up conditions that trigger bug
     const input = {/* conditions that cause bug */}

     // Act: Execute the buggy code
     const result = buggyFunction(input)

     // Assert: What SHOULD happen (but currently doesn't)
     expect(result).toBe(expectedCorrectBehavior)
   })
   ```

### 3.2 Run Test (Must FAIL)

```bash
npm test
```

**Verify**:
- [ ] New test fails
- [ ] Test fails because bug exists (not syntax error)
- [ ] Failure message matches expected bug behavior

**Report to user**:
```
🔴 RED: Test Reproduces Bug

Test: "{test name}"
File: {test file path}:{line number}

Status: FAILING (as expected) ✅
Error: {actual error message}

Reason: {bug behavior}

✅ This confirms the bug exists.

Next: Step 4 - Fix the Bug
```

### 3.3 Update .spec/ File

Mark test creation tasks complete:
```markdown
- [x] Write failing test that reproduces bug
- [x] Verify test fails for correct reason
```

**Report to user after marking tasks complete**:
```
✅ Step 3 Complete: Failing Test Created

Test created: {test file path}
Test status: FAILING (reproduces bug) ✅

Next: Step 4 - Fix the Bug
```

---

## Step 4: Fix the Bug (MINIMAL CHANGE)

**Report to user**:
```
## Step 4: Fix the Bug

File: {implementation file path}
What I'm fixing: {brief description}

Writing minimal code change to fix the bug...
```

### 4.1 Implement Fix

**Principle**: Make the SMALLEST change possible to fix the bug.

- ❌ Don't refactor unrelated code
- ❌ Don't add new features
- ❌ Don't over-engineer
- ✅ Fix ONLY the specific bug
- ✅ Keep change focused and reviewable

### 4.2 Run Tests (Must PASS)

```bash
npm test
```

**Verify**:
- [ ] Bug reproduction test now passes
- [ ] All existing tests still pass (no regressions)
- [ ] Coverage remains at 100%

**If any test fails**:
- Review the failure
- Adjust fix
- Re-run tests
- Repeat until all green

**Report to user**:
```
🟢 GREEN: Bug Fixed

Test: "{test name}"
Status: PASSING ✅

Results:
- Bug reproduction test: ✅ PASSING
- All existing tests: ✅ PASSING ({count}/{count})
- Coverage: {percentage}%

Bug is fixed!

Next: Step 5 - Validation
```

### 4.3 Update .spec/ File

Mark fix tasks complete:
```markdown
- [x] Fix the bug with minimal changes
- [x] Verify fix passes new test
- [x] Verify no regressions
```

**Report to user after marking tasks complete**:
```
✅ Step 4 Complete: Bug Fixed

Fix applied to: {file path}
All tests passing: ✅

Next: Step 5 - Validation (Running 3 validators)
```

---

## Step 5: Validation (MANDATORY)

**Report to user**:
```
## Step 5: Validation

Running 3 validators in parallel:
1. 🧪 Test Suite (coverage check)
2. 🏛️ Architecture Validator
3. 🔍 Static Analysis / Linting

Please wait...
```

All THREE validators must pass.

### 5.1 Run Full Test Suite

```bash
npm test -- --coverage
```

**Requirements**:
- [ ] All tests passing
- [ ] Coverage = 100%

### 5.2 Run Architecture Validator

Read and follow `.workflow/playbooks/architecture-check.md`

**Requirements**:
- [ ] Zero architecture violations
- [ ] Bug fix didn't introduce layer violations

### 5.3 Run Linting

```bash
npm run lint
```

**Requirements**:
- [ ] Zero linting errors
- [ ] Zero TypeScript errors

### 5.4 Manual Verification (if applicable)

If bug was in user-facing functionality:
- Manually test the scenario
- Verify expected behavior
- Check edge cases

### 5.5 Confirm Validation

**Report to user**:
```
✅ Step 5 Complete: Validation

Validation Results:
✅ Tests: {passing}/{total} ({coverage}% coverage)
✅ Architecture: Zero violations
✅ Linting: No issues

All validators PASSED ✅

Bug fix validated!

Next: Step 6 - Finalization & Commit
```

---

## Step 6: Finalization

### 6.1 Update .spec/ Files

Update `.spec/{SEQ_NUM}-fix-{slug}.md`:
1. Mark all tasks complete
2. Set Status to "Completed"
3. Add completion date
4. Update progress to 100%
5. Add summary of fix

### 6.2 Commit Changes

Execute `.workflow/playbooks/commit.md` to:
- Update overall-status.md
- Run validators
- Create git commit with "fix:" prefix
- Report summary

---

## Step 7: Report to User

```
✅ Bug Fixed: {Bug Name}

Fix Summary:
- Root cause: {brief description}
- Location: {file:line}
- Fix: {what was changed}
- Tests added: {count}
- All tests: {passing}/{total} (100%)
- Commit: {hash}

Files changed:
{List of modified files}

Test coverage:
- New test: {test name}
- Coverage maintained: 100%

Verification:
✅ Bug reproduction test passes
✅ No regressions (all existing tests pass)
✅ Architecture compliant
✅ Linting clean
```

---

## Checklist for AI Assistants

Before marking this playbook complete, verify:

- [ ] Step 1: Bug tracking initialized (.spec/{SEQ_NUM}-fix-*.md created with sequence number)
- [ ] Step 2: Root cause identified and documented
- [ ] Step 3: Failing test created BEFORE fix
- [ ] Step 3: Test verified to fail for correct reason
- [ ] Step 4: Bug fixed with minimal change
- [ ] Step 4: All tests passing (new + existing)
- [ ] Step 5: All three validators passed
- [ ] Step 6: Commit playbook executed
- [ ] Step 7: Comprehensive report provided to user

If ANY checkbox is unchecked, playbook is NOT complete.

---

## Notes

- **TDD is critical for bugs** - test ensures bug is truly fixed
- **Minimal changes only** - don't refactor while fixing bugs
- **Test for regressions** - ensure fix doesn't break other things
- **Document root cause** - helps prevent similar bugs
- **Keep fix focused** - one bug per fix, one fix per commit

---

## Error Recovery

### If can't reproduce bug:
1. Ask user for more details
2. Request exact steps to reproduce
3. Check if bug still exists (maybe already fixed?)
4. Try different scenarios
5. If still can't reproduce, inform user

### If fix breaks other tests:
1. Review which tests are failing
2. Understand why (regression or bad test?)
3. Adjust fix to not break existing functionality
4. Re-run all tests
5. Repeat until all green

### If root cause is unclear:
1. Use debugger or logging
2. Add temporary console.log statements
3. Review git history for related changes
4. Ask user for more context
5. Break down investigation into smaller steps
