# Workflow Coordinator Playbook

**Purpose**: Detect user intent and route to appropriate workflow playbook.

**When to use**: For ANY implementation work (features, bugs, refactors, commits).

---

## ⚠️ MANDATORY: Read Reporting Guidelines FIRST ⚠️

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

**RULE**: You MUST announce EVERY step to the user. Silent execution = FAILED workflow.

---

## Step 0: Announce Workflow Start

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

Copy and output this message to the user BEFORE doing anything else:

```
🎯 Workflow Coordinator

Analyzing request: "{user's original request}"

Reading: .workflow/playbooks/coordinator.md

Detecting intent and routing to appropriate workflow...
```

**After outputting the above message, proceed to Step 1.**

---

## Step 1: Detect Intent

Analyze the user's request and classify it:

### Intent Decision Tree

```
Does request contain: "commit", "save changes", "push", "create PR"?
  → YES: Intent = COMMIT (go to Step 2)
  → NO: Continue below

Does request contain: "implement", "add", "create", "build", "new feature"?
  → YES: Intent = FEATURE (go to Step 2)
  → NO: Continue below

Does request contain: "fix", "bug", "error", "broken", "crash", "not working"?
  → YES: Intent = BUGFIX (go to Step 2)
  → NO: Continue below

Does request contain: "refactor", "clean up", "reorganize", "rename", "move"?
  → YES: Intent = REFACTOR (treat as FEATURE, go to Step 2)
  → NO: Continue below

Intent = UNCLEAR
```

### If Intent is UNCLEAR

Ask user to clarify:

```
I'm not sure what type of work this is. Please clarify:

1. **New feature** - Add new functionality
2. **Bug fix** - Fix broken behavior
3. **Refactoring** - Improve code without changing behavior
4. **Commit** - Save current changes
5. **Other** - Please describe

What would you like to do?
```

Wait for user response, then re-run Step 1 immediately without any extra confirmation.

⚠️ **After intent is clarified, continue the coordinator workflow uninterrupted until routing is complete.**

---

## Step 2: Route to Playbook

Based on detected intent, read and execute the appropriate playbook:

| Intent | Playbook to Execute |
|--------|---------------------|
| COMMIT | `.workflow/playbooks/commit.md` |
| FEATURE | `.workflow/playbooks/feature.md` |
| BUGFIX | `.workflow/playbooks/bugfix.md` |
| REFACTOR | `.workflow/playbooks/feature.md` (reuse) |

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

Copy and output this message to the user:

```
✅ Intent Detected: {INTENT}

Routing to: .workflow/playbooks/{playbook-name}.md

Now executing {playbook name} workflow...
```

**After outputting the routing message, do NOT wait for user acknowledgment. Immediately proceed to Step 3 and read the routed playbook. Only pause if the playbook explicitly instructs you to or if you encounter a blocker that requires user input.**

---

## Step 3: Execute Playbook

1. Open the playbook file
2. Follow ALL steps in sequential order
3. Do NOT skip any step marked as "MANDATORY"
4. Complete the playbook fully before reporting back to user

---

## Step 4: Report Completion

After playbook completes, report to user:

```
✅ {Intent} Workflow Complete

Summary:
- Playbook executed: {playbook name}
- Tasks completed: {count}
- Tests: {passing/total} ({coverage}%)
- Commit: {hash} (if committed)
- .spec/ files updated: {yes/no}

{Any additional relevant information}
```

---

## Example Executions

### Example 1: Feature Request

```
User: "implement health check endpoint"

Step 1: Detect Intent
- Contains "implement" → Intent = FEATURE

Step 2: Route to Playbook
- Intent = FEATURE → Execute .workflow/playbooks/feature.md

Step 3: Execute Playbook
[Follows all steps in feature.md]

Step 4: Report
✅ Feature Workflow Complete
Summary:
- Playbook executed: feature.md
- Tasks completed: 15/15
- Tests: 255/255 (100%)
- Commit: abc1234
- .spec/ files updated: yes
```

### Example 2: Commit Request

```
User: "commit these changes"

Step 1: Detect Intent
- Contains "commit" → Intent = COMMIT

Step 2: Route to Playbook
- Intent = COMMIT → Execute .workflow/playbooks/commit.md

Step 3: Execute Playbook
[Follows all steps in commit.md]

Step 4: Report
✅ Commit Workflow Complete
Commit: abc1234
All validators passed ✅
```

### Example 3: Bug Fix Request

```
User: "fix crash when email is null"

Step 1: Detect Intent
- Contains "fix" and "crash" → Intent = BUGFIX

Step 2: Route to Playbook
- Intent = BUGFIX → Execute .workflow/playbooks/bugfix.md

Step 3: Execute Playbook
[Follows all steps in bugfix.md]

Step 4: Report
✅ Bugfix Workflow Complete
Summary:
- Bug fixed and tested
- Tests: 256/256 (100%)
- Commit: def5678
```

---

## Notes

- This playbook is tool-agnostic (works with any AI assistant)
- All workflow logic is in the sub-playbooks, not here
- This coordinator only routes, doesn't execute
- User can manually skip coordinator and go directly to sub-playbooks

---

## Error Handling

### If playbook execution fails:
1. Report the specific step that failed
2. Show the error message
3. Ask user how to proceed (fix or abort)

### If user request is ambiguous:
1. Ask for clarification
2. Wait for user response
3. Re-run Step 1 with clarified request
