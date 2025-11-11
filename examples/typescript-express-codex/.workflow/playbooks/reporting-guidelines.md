# Reporting Guidelines for AI Assistants

**Purpose**: Enforce clear, consistent communication during workflow execution.

**MANDATORY**: All AI assistants MUST follow these reporting guidelines when executing playbooks.

---

## ⚠️ CRITICAL ENFORCEMENT RULE ⚠️

**THIS IS NOT OPTIONAL. THIS IS NOT A SUGGESTION.**

Every time you see **"Report to user:"** in a playbook:
1. **STOP** what you're doing
2. **COPY** the exact reporting template
3. **OUTPUT** it to the user with filled-in values
4. **ONLY THEN** continue with the next action

**Violation of reporting = workflow failure.**

If you execute ANY action without first reporting it to the user, you have FAILED the workflow.

---

## Core Principle

**ALWAYS announce what you're doing BEFORE you do it.**

This is NOT for your benefit. This is for the USER to see what's happening.

Users need visibility into:
1. Which playbook you're executing ← **ANNOUNCE THIS FIRST**
2. What step you're on ← **ANNOUNCE BEFORE EACH STEP**
3. What you're doing right now ← **ANNOUNCE BEFORE EACH ACTION**
4. Progress through the workflow ← **ANNOUNCE AFTER EACH STEP**
5. Results of each step ← **ANNOUNCE EVERY RESULT**

---

## How to Use This Document

When a playbook says **"Report to user:"**, you MUST:

1. **Find the reporting template** in that section
2. **Fill in the placeholders** with actual values (e.g., replace `{feature_name}` with actual feature name)
3. **Output the formatted message** to the user
4. **Continue to next action** (don't wait for response)

**Example**:
- Playbook says: "Report to user: Step 1 complete"
- You output: "✅ Step 1 Complete: Initialize Task Tracking"
- You immediately continue to Step 2

---

## Workflow Announcement Format

### At Start of ANY Workflow

**WHEN**: Every time you start executing a playbook

**ACTION**: Output this message BEFORE doing anything else

**Template**:
```
🎯 Workflow: {Playbook Name}

Detected Intent: {FEATURE|BUGFIX|REFACTOR|COMMIT}
User Request: "{original request}"

Executing: .workflow/playbooks/{playbook-name}.md

I'll now follow this workflow step-by-step and report progress.
```

**Example**:
```
🎯 Workflow: Feature Implementation

Detected Intent: FEATURE
User Request: "implement health check endpoint"

Executing: .workflow/playbooks/feature.md

I'll now follow this workflow step-by-step and report progress.
```

---

## Step Announcement Format

### Before EVERY Step

**WHEN**: Before executing ANY step in the playbook

**ACTION**: Output this message, then execute the step

**MANDATORY**: Do NOT skip this. Do NOT execute the step silently.

**Template**:
```
## Step {number}: {Step Name}

What I'm doing: {brief description}

{Show the actual step being executed}
```

**Example**:
```
## Step 1: Initialize Task Tracking

What I'm doing: Creating .spec/ file to track this feature

Creating: .spec/feature-health-check.md
Updating: .spec/overall-status.md
```

**After outputting this, IMMEDIATELY execute Step 1 actions.**

---

## Progress Reporting

### After Each Major Step

**WHEN**: After completing ANY step in the playbook

**ACTION**: Output this message, then move to next step

**MANDATORY**: Always report completion. Never skip to next step silently.

**Template**:
```
✅ Step {number} Complete: {Step Name}

Result:
- {Key outcome 1}
- {Key outcome 2}

Next: Step {number+1} - {Next Step Name}
```

**Example**:
```
✅ Step 1 Complete: Initialize Task Tracking

Result:
- Created .spec/feature-health-check.md
- Updated .spec/overall-status.md
- Tracked 9 tasks (0% complete)

Next: Step 2 - Exploration & Planning
```

---

## Sub-Step Reporting

When a step in a playbook is divided into sub-steps (e.g., Step 2.1, 2.2, 2.3), you MUST report on the start and completion of each individual sub-step. The reporting format should be similar to the main step announcement.

**Example**:
```
## Step 2: Investigation & Root Cause Analysis

### Starting Step 2.1: Locate Affected Code
...
✅ Completed Step 2.1.

### Starting Step 2.2: Reproduce Bug
...
✅ Completed Step 2.2.
```

---

## TDD Cycle Reporting

### Red Phase

**Template**:
```
🔴 RED: Writing Failing Test

Test: "{test name}"
File: {test file path}
What it tests: {description}

[Show the test code being written]

Running test... (expecting failure)
```

**After running**:
```
🔴 Test FAILED (Expected)

Reason: {why it failed}
Error: {error message}

✅ This is correct - feature doesn't exist yet.

Next: GREEN - Write minimal implementation
```

### Green Phase

**Template**:
```
🟢 GREEN: Writing Implementation

File: {implementation file path}
What I'm adding: {description}

[Show the code being written]

Running tests... (expecting all to pass)
```

**After running**:
```
🟢 All Tests PASSING

Results:
- New test: ✅ PASSING
- All existing tests: ✅ PASSING ({count}/{count})
- Coverage: {percentage}%

Next: REFACTOR (optional) or move to next task
```

### Refactor Phase (Optional)

**Template**:
```
🔵 REFACTOR: Improving Code Quality

Improvements:
- {improvement 1}
- {improvement 2}

[Show refactoring changes]

Running tests... (must stay green)
```

---

## Validation Reporting

### Running Validators

**Template**:
```
## Validation Phase

Running 3 validators in parallel:
1. 🧪 Test Suite (coverage check)
2. 🏛️ Architecture Validator
3. 🔍 Static Analysis / Linting

Please wait...
```

**After Completion**:
```
## Validation Results

✅ Test Suite: {count}/{count} passing ({coverage}% coverage)
✅ Architecture: Zero violations
✅ Static Analysis: Zero errors

All validators PASSED ✅

Ready to commit.
```

**If ANY Fail**:
```
## Validation Results

❌ Test Suite: {failures} failing
✅ Architecture: Zero violations
❌ Static Analysis: {count} errors

Cannot proceed - fixing issues...

Issues to fix:
1. {issue 1}
2. {issue 2}
```

---

## Commit Reporting

### Before Commit

**Template**:
```
## Creating Git Commit

Type: {feat|fix|refactor|test|docs|chore}
Subject: {commit subject}

Files to commit:
- {file 1}
- {file 2}

Commit message:
```
{full commit message}
```

Creating commit...
```

### After Commit

**Template**:
```
✅ Commit Created Successfully

Commit: {hash}
Files changed: {count}
Insertions: +{count} lines
Deletions: -{count} lines

Commit message:
{subject line}
```

---

## Progress Summary

### After Every Major Milestone

**Template**:
```
📊 Progress Update

Feature: {feature name}
Completed: {X}/{total} tasks ({percentage}%)
Current: {current task name}

Status:
✅ {completed task 1}
✅ {completed task 2}
🔄 {in progress task}
⏳ {pending task 1}
⏳ {pending task 2}
```

---

## Final Completion Report

### At End of Workflow

**Template**:
```
✅ {Workflow Type} Complete: {Feature/Bug/Work Name}

Summary:
- Playbook executed: {playbook name}
- Tasks completed: {count}/{total} (100%)
- Tests: {passing}/{total} ({coverage}%)
- Commit: {hash}
- .spec/ files: Updated ✅

Implementation:
{Brief description of what was done}

Files changed:
- {file 1}
- {file 2}

Validation:
✅ Tests passing
✅ Architecture compliant
✅ No linting errors

Next steps:
{What user can do next, if applicable}
```

---

## Error Reporting

### When Something Fails

**Template**:
```
❌ Error in Step {number}: {Step Name}

What failed: {description}

Error:
```
{error message}
```

Attempting to fix:
{What you're doing to resolve it}

OR

Please help:
{What you need from user}
```

---

## Examples of Good vs Bad Reporting

### ❌ BAD (Silent Execution)

```
User: "implement health check"
AI: [silently creates files, writes tests, writes code]
AI: "Done. Commit: abc1234"
```

**Problem**: User has no idea what happened or how.

### ✅ GOOD (Visible Execution)

```
User: "implement health check"

AI:
🎯 Workflow: Feature Implementation
Detected Intent: FEATURE
Executing: .workflow/playbooks/feature.md

## Step 1: Initialize Task Tracking
Creating .spec/feature-health-check.md...
✅ Task tracking initialized (9 tasks)

## Step 2: TDD Implementation

🔴 RED: Writing Failing Test
Test: "should return 200 OK with status"
File: tests/e2e/health.test.ts
Running test... FAILED ✅ (expected)

🟢 GREEN: Writing Implementation
File: src/index.ts
Adding health endpoint...
Running tests... ALL PASSING ✅ (254/254)

## Step 3: Validation
Running 3 validators in parallel...
✅ All validators PASSED

## Step 4: Commit
Creating commit...
✅ Commit: abc1234

✅ Feature Complete: Health Check Endpoint
Tasks: 9/9 (100%)
Tests: 254/254 passing
Ready for review!
```

**Why it's good**: User sees every step, understands what's happening, and has confidence in the process.

---

## Mandatory Reporting Checkpoints

AI assistants MUST report at these points:

- [ ] **Start of workflow** - Announce playbook being executed
- [ ] **Start of each step** - Announce step number and name
- [ ] **Before TDD phases** - Announce RED/GREEN/REFACTOR
- [ ] **After running tests** - Show pass/fail status
- [ ] **Before validation** - Announce validators being run
- [ ] **After validation** - Show all results
- [ ] **Before commit** - Show commit details
- [ ] **After commit** - Show commit hash
- [ ] **End of workflow** - Comprehensive summary
- [ ] **On errors** - Clear error messages with context

---

## Visual Indicators

Use these consistently:

| Symbol | Meaning |
|--------|---------|
| 🎯 | Workflow start |
| 🔴 | RED - Failing test |
| 🟢 | GREEN - Passing test |
| 🔵 | REFACTOR - Code improvement |
| ✅ | Success / Passed |
| ❌ | Failed / Error |
| 🔄 | In progress |
| ⏳ | Pending / Waiting |
| 📊 | Progress update |
| 🧪 | Tests |
| 🏛️ | Architecture |
| 🔍 | Linting/Analysis |
| 🚀 | Feature started |
| 🎉 | Work completed |

---

## Enforcement

**Every playbook MUST**:
1. Reference these reporting guidelines
2. Include explicit "Report to user" steps
3. Provide response templates
4. Enforce visibility at each checkpoint

**AI assistants MUST**:
1. Read this guideline before executing any playbook
2. Follow the reporting formats exactly
3. Never execute steps silently
4. Always show progress

---

## For Manual Execution (Humans)

When following playbooks manually:
- Announce each step out loud (to yourself or team)
- Check off completed steps
- Document outcomes
- Communicate progress to stakeholders

Same visibility principles apply!
