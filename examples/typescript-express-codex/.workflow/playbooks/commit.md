# Commit Workflow Playbook

**Purpose**: Pre-commit validation and task tracking update.

**When to use**: Before EVERY git commit (mandatory).

---

## IMPORTANT: Read Reporting Guidelines FIRST

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

You MUST announce each validation step and show results clearly to the user.

---

## Step 0: Announce Workflow Start

**Report to user**:
```
🎯 Commit Workflow

Executing: .workflow/playbooks/commit.md

This workflow will:
1. Update task tracking (.spec/ files)
2. Run 3 validators in parallel (tests, linting, architecture)
3. Create git commit
4. Report commit summary

Let's begin...
```

---

## Prerequisites Check

Before starting, verify:

- [ ] There are uncommitted changes (`git status` shows changes)
- [ ] All implementation work is complete
- [ ] You have NOT already committed (this runs BEFORE commit)

If any prerequisite fails, STOP and inform user.

---

## Step 1: Update Task Tracking (MANDATORY)

**Report to user**:
```
## Step 1: Update Task Tracking

Syncing .spec/ files with completed work...
```

### 1.1 Read Git History

```bash
git log --oneline -10
git diff --staged
git diff HEAD
```

Understand what work was done since last commit.

### 1.2 Update .spec/ Files

For each `.spec/*.md` file related to recent work:

1. Read the file
2. Find tasks that match the completed work
3. Mark those tasks as complete: `- [x]`
4. Update progress percentage
5. Add notes if needed
6. Update timestamps

**Formula for progress**:
```
Progress = (Completed tasks / Total tasks) × 100
```

Example update:
```markdown
### Implementation
- [x] Write entity tests
- [x] Implement entities
- [ ] Write use case tests
- [ ] Implement use cases

Progress: 50% (2/4 tasks)
```

### 1.3 Update .spec/overall-status.md

1. Read `.spec/overall-status.md`
2. Update completion statistics for the feature/fix
3. Update "Recently Completed" section if work is 100% done
4. Update "Recent Activity" section with timestamp
5. Recalculate totals:
   - Total features/fixes
   - Completed count
   - In Progress count
   - Overall completion percentage

### 1.4 Verify Updates

Review what was updated:
```bash
git diff .spec/
```

**Report to user**:
```
✅ Step 1 Complete: Task Tracking Updated

Updated files:
- .spec/feature-xyz.md ({completed}/{total} tasks, {percentage}%)
- .spec/overall-status.md

Changes staged for commit.

Next: Step 2 - Run Validators (3 validators in parallel)
```

---

## Step 2: Run Validators (MANDATORY)

**Report to user**:
```
## Step 2: Running Validators

Executing 3 validators in parallel:
1. 🧪 Test Suite (npm test -- --coverage)
2. 🔍 Static Analysis (npm run lint)
3. 🏛️ Architecture Validation (.workflow/playbooks/architecture-check.md)

Please wait...
```

All THREE validators must run in parallel and ALL must pass.

### 2.1 Launch Validators in Parallel

Run these commands concurrently (if your AI tool supports parallel execution):

**Validator 1: Test Suite**
```bash
npm test -- --coverage
```

**Validator 2: Static Analysis**
```bash
npm run lint
```

**Validator 3: Architecture Validation**
Read and follow `.workflow/playbooks/architecture-check.md`

### 2.2 Collect Results

**AUTOMATICALLY wait for all three processes to complete (not user input).** Collect:
- Exit codes (0 = pass, non-zero = fail)
- Test coverage percentage
- Number of tests passing/total
- Linting issues count
- Architecture violations count

### 2.3 Evaluate Results

**If ANY validator fails:**

**Report to user**:
```
❌ Validation Failed

Results:
{List each validator with its status}

Example:
✅ Tests: {passing}/{total} ({coverage}%)
❌ Linting: {count} errors found
✅ Architecture: Zero violations

Cannot commit until all validators pass.

Fixing issues before proceeding...
```

**EXCEPTION: STOP here and wait for user to fix issues, then re-run Step 2. Do NOT proceed to Step 3.**

**If ALL validators pass:**

**IMMEDIATELY AND AUTOMATICALLY continue to Step 3. DO NOT wait for user confirmation.**

**Report to user**:
```
✅ Step 2 Complete: All Validators Passed

Validation Results:
✅ Tests: {passing}/{total} ({coverage}% coverage)
✅ Linting: No issues
✅ Architecture: Zero violations

All validators PASSED ✅

Next: Step 3 - Create Git Commit
```

Continue to Step 3.

---

## Step 3: Create Git Commit (MANDATORY)

**Report to user**:
```
## Step 3: Creating Git Commit

Determining commit type and creating commit message...
```

### 3.1 Stage .spec/ Files

```bash
git add .spec/
```

Verify:
```bash
git status
```

Confirm `.spec/` files are staged along with your implementation changes.

### 3.2 Determine Commit Type

Based on the changes, determine commit type:

| Change Type | Commit Type | Example |
|-------------|-------------|---------|
| New feature/endpoint | `feat` | "feat: add health check endpoint" |
| Bug fix | `fix` | "fix: handle null email addresses" |
| Code refactoring | `refactor` | "refactor: extract user validation logic" |
| Test additions/updates | `test` | "test: add edge cases for calculator" |
| Documentation only | `docs` | "docs: update API documentation" |
| Maintenance/tooling | `chore` | "chore: update dependencies" |

### 3.3 Create Commit Message

**Format**:
```
<type>: <short description>

<optional body>
```

**Requirements**:
- **type**: One of: feat, fix, refactor, test, docs, chore
- **short description**:
  - Imperative mood ("add" not "added" or "adds")
  - Lowercase
  - Max 50 characters
  - No period at end
- **optional body**:
  - Explain WHY (not WHAT)
  - Separate from subject with blank line
  - Wrap at 72 characters

**Example**:
```
feat: add health check endpoint at /ping

Provides basic health monitoring for load balancers
and enables automated uptime checks.
```

**Constraints (from user's global instructions)**:
- ❌ NO Claude-specific comments
- ❌ NO co-author attribution (like "Co-Authored-By: Claude")
- ❌ NO emojis (unless user explicitly requested)

### 3.4 Execute Commit

```bash
git commit -m "type: subject

optional body"
```

Or use heredoc for multi-line:
```bash
git commit -m "$(cat <<'EOF'
feat: add health check endpoint

Provides basic health monitoring.
EOF
)"
```

Capture the commit hash from output.

### 3.5 Verify Commit

```bash
git log -1 --oneline
git show HEAD --stat
```

Confirm commit was created successfully.

**Report to user**:
```
✅ Step 3 Complete: Commit Created

Commit: {hash}
Type: {feat|fix|refactor|test|docs|chore}
Message: {commit subject line}

Files changed: {count}
Insertions: +{lines} lines
Deletions: -{lines} lines

Next: Step 4 - Post-Commit Updates (optional)
```

---

## Step 4: Post-Commit Updates (OPTIONAL)

### 4.1 Add Commit Hash to .spec/ Files

Now that commit exists, optionally add commit reference:

1. Re-open the .spec/ files you updated in Step 1.2
2. Add the actual commit hash to completed tasks
3. Save files

Example:
```markdown
- [x] Implement health check endpoint (Commit: abc1234)
```

### 4.2 Stage and Amend (if you added commit hashes)

```bash
git add .spec/
git commit --amend --no-edit
```

This adds the .spec/ updates to the same commit.

**Note**: Only do this if:
- Commit hasn't been pushed yet
- You're the only author of the commit
- It's safe to rewrite history

---

## Step 5: Report to User

```
✅ Commit Workflow Complete

Commit: {hash}
Type: {type}
Message: {subject line}

Validation Results:
✅ Tests: {passing}/{total} ({coverage}%)
✅ Linting: Passed
✅ Architecture: Passed

Files Changed: {count}
.spec/ Files Updated:
- {file1} ({progress}%)
- {file2} ({progress}%)

Statistics (from .spec/overall-status.md):
- Features Completed: {completed}/{total}
- Test Coverage: {coverage}%
- Open Tasks: {count}
```

---

## Checklist for AI Assistants

Before marking this playbook complete, verify:

- [ ] Step 1: .spec/ files updated with task completion
- [ ] Step 1: .spec/overall-status.md updated with statistics
- [ ] Step 2: ALL three validators executed (ideally in parallel)
- [ ] Step 2: ALL validators passed (100% - no exceptions)
- [ ] Step 3: .spec/ files staged with `git add .spec/`
- [ ] Step 3: Commit created with proper message format
- [ ] Step 3: Commit message follows constraints (no Claude comments, etc.)
- [ ] Step 4: Post-commit updates done (if applicable)
- [ ] Step 5: Comprehensive report provided to user

If ANY item unchecked, playbook is NOT complete.

---

## Error Recovery

### If validators fail mid-workflow

1. Report failures to user clearly
2. Show specific errors from each failing validator
3. Do NOT continue to Step 3
4. **EXCEPTION: ONLY in this case, wait for user to fix issues**
5. Offer to re-run from Step 2 after fixes

### If commit fails

1. Report git error to user
2. Check if commit message format is correct
3. Check if there are merge conflicts
4. Check if pre-commit hooks are blocking
5. Resolve issue and retry Step 3

### If .spec/ updates fail

1. Check if .spec/ directory exists
2. Check if files are readable/writable
3. Verify file paths are correct
4. Report specific file error to user
5. Create missing files if needed

---

## Notes for Different AI Assistants

**Claude Code**:
- Use parallel tool execution for Step 2.1 validators when possible
- Use MCP git tools for commit operations
- Use Read/Edit tools for .spec/ file updates

**ChatGPT**:
- Suggest user runs validator commands manually
- Provide exact copy/paste commands
- Guide through manual .spec/ file updates if needed

**Cursor**:
- Execute commands directly via integrated terminal
- Show validator output inline
- Auto-stage files

**Manual Execution**:
- Follow checklist step-by-step
- Run each validator command manually
- Manually update .spec/ files
- Verify each step before proceeding

---

## Validator Details

### Test Suite Validator
- Command: `npm test -- --coverage`
- Pass criteria: All tests passing, 100% coverage
- Output: Test count, coverage percentages

### Linting Validator
- Command: `npm run lint`
- Pass criteria: Zero errors, zero warnings
- Output: List of issues (if any)

### Architecture Validator
- Playbook: `.workflow/playbooks/architecture-check.md`
- Pass criteria: Zero violations
- Output: Dependency graph compliance report
