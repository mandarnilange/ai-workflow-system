# PRD Planning Playbook

**Purpose**: Plan and create spec files for multiple features from a PRD without implementing them.

**When to use**: When you need to plan multiple features upfront, break down a PRD, or prepare specs before implementation.

---

## ⚠️ MANDATORY: Read Reporting Guidelines FIRST ⚠️

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

**RULE**: You MUST announce EVERY step to the user. Silent execution = FAILED workflow.

---

## Step 0: Announce Workflow Start

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

Copy and output this message to the user BEFORE doing anything else:

```
🎯 PRD Planning Workflow

Input: {brief description of PRD or feature list}

Executing: .workflow/playbooks/prd-planning.md

This workflow will:
1. Analyze PRD and extract features
2. Create .spec/ files for each feature (Status: Pending)
3. Update overall-status.md with all planned features
4. Provide implementation recommendations

Note: This workflow does NOT implement features - it only creates planning artifacts.

Let's begin...
```

**After outputting the above message, proceed to Step 1.**

---

## Step 1: Analyze PRD Input

### 1.1 Understand Input Format

The user may provide:
- **Structured PRD**: Markdown document with features list
- **Unstructured Description**: Paragraph describing multiple features
- **Bullet List**: Simple list of features
- **Feature Names Only**: Comma-separated or numbered list

### 1.2 Extract Features

Analyze the input and extract:
- Feature name/title
- Brief description (if provided)
- Priority (if mentioned: High, Medium, Low)
- Dependencies (if mentioned)
- Acceptance criteria (if provided)

### 1.3 Validate Understanding

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE 🚨**

```
✅ PRD Analysis Complete

I've identified the following features:

1. {Feature Name 1}
   - Description: {brief description or "Not specified"}
   - Priority: {High|Medium|Low or "Not specified"}
   - Dependencies: {list or "None"}

2. {Feature Name 2}
   - Description: {brief description or "Not specified"}
   - Priority: {High|Medium|Low or "Not specified"}
   - Dependencies: {list or "None"}

3. {Feature Name 3}
   - Description: {brief description or "Not specified"}
   - Priority: {High|Medium|Low or "Not specified"}
   - Dependencies: {list or "None"}

Total Features: {X}

Is this correct? Should I proceed with creating spec files?
```

**Wait for user confirmation before proceeding to Step 2.**

If user requests changes:
- Update the feature list
- Re-output the updated list
- Wait for confirmation again

Only proceed to Step 2 after user confirms.

---

## Step 2: Initialize .spec/ Directory

### 2.1 Check for Existing .spec/ Directory

Check if `.spec/` directory exists:
- If exists: Continue (will add to existing specs)
- If not exists: Create `.spec/` directory

### 2.2 Check for Sequence File

Check if `.spec/.sequence` exists:
- If exists: Read current sequence number
- If not exists: Create `.spec/.sequence` with content: `000`

### 2.3 Announce Initialization

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE 🚨**

```
📁 Initializing .spec/ Directory

Current sequence number: {XXX}
Next feature will be: {XXX+1}

Creating spec files for {X} features...
```

---

## Step 3: Create Feature Spec Files

For EACH feature identified in Step 1, perform the following:

### 3.1 Generate Sequence Number

- Read current sequence from `.spec/.sequence`
- Increment by 1
- Zero-pad to 3 digits (e.g., 001, 002, 003)
- Update `.spec/.sequence` with new value

### 3.2 Generate Slug

Convert feature name to URL-friendly slug:
- Convert to lowercase
- Replace spaces with hyphens
- Remove special characters
- Example: "User Authentication" → "user-authentication"

### 3.3 Create Spec File

Create file: `.spec/{SEQ_NUM}-feature-{slug}.md`

Use the template from `templates/feature-template.md` with these modifications:

**IMPORTANT CHANGES**:
- **Status**: Set to "Pending" (NOT "In Progress")
- **Started**: Set to "N/A"
- **Completed**: Set to "N/A"
- **Priority**: Use value from Step 1 (or "Medium" if not specified)
- **Overview**: Use description from Step 1 (or placeholder if not provided)
- **Tasks**: Keep all task checkboxes UNCHECKED
- **Progress**: Set to "Total Tasks: 24, Completed: 0, In Progress: 0, Blocked: 0, Completion: 0%"
- **Related Work**:
  - **Dependencies**: List features this depends on (from Step 1 analysis)
  - **Dependents**: Leave blank (will be filled during implementation)

### 3.4 Announce File Creation

After creating EACH spec file, output:

```
✅ Created: .spec/{SEQ_NUM}-feature-{slug}.md
   - Sequence: {SEQ_NUM}
   - Status: Pending
   - Priority: {High|Medium|Low}
   - Tasks: 0/24 (0%)
```

### 3.5 Repeat for All Features

Continue Steps 3.1-3.4 for EVERY feature identified in Step 1.

---

## Step 4: Update Overall Status Dashboard

### 4.1 Check for Existing Dashboard

Check if `.spec/overall-status.md` exists:
- If exists: Update it (preserve existing data, add new features)
- If not exists: Create new dashboard from `templates/overall-status-template.md`

### 4.2 Update Dashboard Content

Update the following sections:

#### Summary Section
```markdown
## Summary

- Total Features: {count of all features in .spec/}
- Completed: {count with Status: Completed} ({XX}%)
- In Progress: {count with Status: In Progress}
- Pending: {count with Status: Pending}
- Blocked: {count with Status: Blocked}
```

#### Upcoming Section
```markdown
### Upcoming

1. [Feature: {Name}]({SEQ_NUM}-feature-{slug}.md) - Pending (Priority: {High|Medium|Low})
2. [Feature: {Name}]({SEQ_NUM}-feature-{slug}.md) - Pending (Priority: {High|Medium|Low})
3. [Feature: {Name}]({SEQ_NUM}-feature-{slug}.md) - Pending (Priority: {High|Medium|Low})
...
```

#### Recent Activity Section
Add entry:
```markdown
- {YYYY-MM-DD HH:MM:SS}: PRD Planning - Added {X} new features to backlog
```

### 4.3 Announce Dashboard Update

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE 🚨**

```
✅ Updated: .spec/overall-status.md

Dashboard Summary:
- Total Features: {X}
- Pending: {Y} (newly added)
- In Progress: {Z} (existing)
- Completed: {W} (existing)
```

---

## Step 5: Generate Implementation Recommendations

### 5.1 Analyze Dependencies

Review all created spec files and identify:
- Features with NO dependencies (can be implemented first)
- Features with dependencies (must wait for dependencies)
- Dependency chains (Feature C depends on B, B depends on A)

### 5.2 Recommend Implementation Order

Based on:
- Dependencies (no-dependency features first)
- Priority (High → Medium → Low)
- Complexity (simpler features first, if possible)

Generate recommended implementation order.

### 5.3 Output Recommendations

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE 🚨**

```
📋 Implementation Recommendations

Recommended implementation order:

Phase 1 - No Dependencies (can start immediately):
1. [{SEQ_NUM}-feature-{slug}] {Feature Name} (Priority: {High|Medium|Low})
2. [{SEQ_NUM}-feature-{slug}] {Feature Name} (Priority: {High|Medium|Low})

Phase 2 - Depends on Phase 1:
3. [{SEQ_NUM}-feature-{slug}] {Feature Name} (Priority: {High|Medium|Low})
   - Depends on: Feature X, Feature Y
4. [{SEQ_NUM}-feature-{slug}] {Feature Name} (Priority: {High|Medium|Low})
   - Depends on: Feature X

Phase 3 - Depends on Phase 2:
5. [{SEQ_NUM}-feature-{slug}] {Feature Name} (Priority: {High|Medium|Low})
   - Depends on: Feature Z

To implement a feature, use:
"Implement feature {SEQ_NUM}" or "Implement {feature name}"
```

---

## Step 6: Provide Next Steps

**🚨 ACTION REQUIRED - OUTPUT THIS MESSAGE NOW 🚨**

```
✅ PRD Planning Workflow Complete

Summary:
- Features planned: {X}
- Spec files created: {X}
- Dashboard updated: Yes
- Ready for implementation: {count of no-dependency features}

Files created:
{list all .spec/XXX-feature-*.md files}

Updated files:
- .spec/overall-status.md
- .spec/.sequence (now at {XXX})

Next Steps:
1. Review spec files in .spec/ directory
2. Add more detail to feature descriptions if needed
3. Validate dependencies and priorities
4. Start implementation with: "Implement feature {SEQ_NUM}"

Recommended first implementation:
- {Feature Name} (.spec/{SEQ_NUM}-feature-{slug}.md) - No dependencies, {Priority} priority
```

---

## Step 7: Optional - Create PRD Summary Document

**Only if user requests a summary document.**

Create `.spec/prd-summary.md` with:

```markdown
# PRD Summary

**Date**: {YYYY-MM-DD}
**Features**: {X}
**Status**: Planning Complete

## Overview

{Brief description of the PRD/project}

## Features

### High Priority
- [{SEQ_NUM}-feature-{slug}]({SEQ_NUM}-feature-{slug}.md) - {Feature Name}
- [{SEQ_NUM}-feature-{slug}]({SEQ_NUM}-feature-{slug}.md) - {Feature Name}

### Medium Priority
- [{SEQ_NUM}-feature-{slug}]({SEQ_NUM}-feature-{slug}.md) - {Feature Name}

### Low Priority
- [{SEQ_NUM}-feature-{slug}]({SEQ_NUM}-feature-{slug}.md) - {Feature Name}

## Dependencies

Feature {X} → Feature {Y} → Feature {Z}

## Timeline Estimate

(Optional - based on feature count and complexity)
- Phase 1: {X} features ({Y} days estimated)
- Phase 2: {X} features ({Y} days estimated)
- Phase 3: {X} features ({Y} days estimated)

Total estimated: {X} days
```

---

## Notes

### Key Principles

1. **Planning Only**: This playbook does NOT implement features
2. **Status: Pending**: All created spec files have Status: Pending
3. **Preserve Existing**: Don't overwrite existing .spec/ files
4. **Sequence Management**: Increment .sequence for each new feature
5. **Dependency Tracking**: Analyze and document feature dependencies
6. **User Confirmation**: Always confirm feature list before creating files

### What This Playbook Does NOT Do

- ❌ Does NOT implement features
- ❌ Does NOT write tests
- ❌ Does NOT write code
- ❌ Does NOT run validators
- ❌ Does NOT create git commits

### What Happens After Planning

After this playbook completes:
- User reviews spec files
- User can edit specs to add more detail
- User selects a feature to implement
- User triggers feature.md playbook with: "Implement feature {SEQ_NUM}"
- feature.md playbook handles TDD implementation

---

## Error Handling

### If .spec/ directory has permission issues:
```
ERROR: Cannot create .spec/ directory (permission denied)

Please ensure the project directory has write permissions.
```

### If sequence file is corrupted:
```
WARNING: .spec/.sequence is corrupted or invalid

Resetting sequence to {highest existing sequence + 1}
```

### If user provides unclear PRD:
```
⚠️ PRD Analysis Incomplete

I need more information about:
- Feature names (clear titles)
- Brief descriptions (what each feature does)
- Priorities (optional, but helpful)

Please provide a clearer feature list or PRD.
```

---

## Example Execution

### Input
```
User: "Plan a PRD with 3 features: user authentication, product catalog, and shopping cart.
Product catalog depends on user auth. Shopping cart depends on both."
```

### Output
```
🎯 PRD Planning Workflow

Input: PRD with 3 features (user auth, product catalog, shopping cart)

Executing: .workflow/playbooks/prd-planning.md

This workflow will:
1. Analyze PRD and extract features
2. Create .spec/ files for each feature (Status: Pending)
3. Update overall-status.md with all planned features
4. Provide implementation recommendations

Let's begin...

---

✅ PRD Analysis Complete

I've identified the following features:

1. User Authentication
   - Description: User authentication system
   - Priority: Not specified
   - Dependencies: None

2. Product Catalog
   - Description: Product catalog browsing
   - Priority: Not specified
   - Dependencies: User Authentication

3. Shopping Cart
   - Description: Shopping cart functionality
   - Priority: Not specified
   - Dependencies: User Authentication, Product Catalog

Total Features: 3

Is this correct? Should I proceed with creating spec files?

[User confirms]

---

📁 Initializing .spec/ Directory

Current sequence number: 000
Next feature will be: 001

Creating spec files for 3 features...

✅ Created: .spec/001-feature-user-authentication.md
   - Sequence: 001
   - Status: Pending
   - Priority: Medium
   - Tasks: 0/24 (0%)

✅ Created: .spec/002-feature-product-catalog.md
   - Sequence: 002
   - Status: Pending
   - Priority: Medium
   - Tasks: 0/24 (0%)

✅ Created: .spec/003-feature-shopping-cart.md
   - Sequence: 003
   - Status: Pending
   - Priority: Medium
   - Tasks: 0/24 (0%)

---

✅ Updated: .spec/overall-status.md

Dashboard Summary:
- Total Features: 3
- Pending: 3 (newly added)
- In Progress: 0
- Completed: 0

---

📋 Implementation Recommendations

Recommended implementation order:

Phase 1 - No Dependencies (can start immediately):
1. [001-feature-user-authentication] User Authentication (Priority: Medium)

Phase 2 - Depends on Phase 1:
2. [002-feature-product-catalog] Product Catalog (Priority: Medium)
   - Depends on: User Authentication

Phase 3 - Depends on Phase 2:
3. [003-feature-shopping-cart] Shopping Cart (Priority: Medium)
   - Depends on: User Authentication, Product Catalog

To implement a feature, use:
"Implement feature 001" or "Implement user authentication"

---

✅ PRD Planning Workflow Complete

Summary:
- Features planned: 3
- Spec files created: 3
- Dashboard updated: Yes
- Ready for implementation: 1

Files created:
- .spec/001-feature-user-authentication.md
- .spec/002-feature-product-catalog.md
- .spec/003-feature-shopping-cart.md

Updated files:
- .spec/overall-status.md
- .spec/.sequence (now at 003)

Next Steps:
1. Review spec files in .spec/ directory
2. Add more detail to feature descriptions if needed
3. Validate dependencies and priorities
4. Start implementation with: "Implement feature 001"

Recommended first implementation:
- User Authentication (.spec/001-feature-user-authentication.md) - No dependencies, Medium priority
```

---

## Integration with Other Playbooks

### After PRD Planning

When user is ready to implement:
- User: "Implement feature 001" or "Implement user authentication"
- coordinator.md detects FEATURE intent
- Routes to feature.md
- feature.md finds existing .spec/001-feature-user-authentication.md
- Updates Status: Pending → In Progress
- Executes TDD workflow
- Updates Status: In Progress → Completed

### Coordinator Integration

The coordinator.md will detect PLAN intent with keywords:
- "plan", "PRD", "spec", "outline", "breakdown", "prepare"

And route to this playbook.

---

## Continuous Improvement

This playbook will evolve to support:
- Epics (groups of related features)
- User stories (more detailed requirements)
- Acceptance criteria (explicit validation rules)
- Estimation (story points, time estimates)
- Sprint planning (grouping features into sprints)
