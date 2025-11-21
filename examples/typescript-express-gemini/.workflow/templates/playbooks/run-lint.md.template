# Run Linter Playbook

**Purpose**: Execute static analysis and linting checks.

**When to use**: During pre-commit validation, or when explicitly requested to run linting.

---

## IMPORTANT: Read Reporting Guidelines FIRST

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

You MUST announce linting progress to keep the user informed.

---

## Step 0: Announce Linting Start

**Report to user**:
```
🔍 Static Analysis

Executing: .workflow/playbooks/run-lint.md

Running linter to check code quality...
```

---

## Step 1: Load Linter Configuration

Read linter configuration from `.workflow/config.yml`:

```yaml
quality:
  linter: "{LINTER}"
  lint_command: "{LINT_COMMAND}"
  formatter: "{FORMATTER}"
```

Use the `lint_command` value from config. If not set, use default based on linter.

---

## Step 2: Execute Linter

Run the lint command:

```bash
{lint_command from config}
```

**Examples by language/tool**:
- ESLint (JavaScript/TypeScript): `npm run lint` or `eslint .`
- Pylint (Python): `pylint src/`
- Checkstyle (Java): `mvn checkstyle:check`
- RuboCop (Ruby): `rubocop`
- golangci-lint (Go): `golangci-lint run`

---

## Step 3: Collect Results

Capture the following information:
- Exit code (0 = pass, non-zero = fail)
- Total number of issues found
- Issues by severity (errors, warnings, info)
- Affected files count
- Specific issue messages and locations

---

## Step 4: Report Results

**If linting passes (no issues)**:

**Report to user**:
```
✅ Linting Passed

Results:
- Issues: 0 errors, 0 warnings
- Files checked: {file_count}
- Duration: {duration}

Code quality checks passed.
```

**If linting fails (issues found)**:

**Report to user**:
```
❌ Linting Failed

Results:
- Issues: {error_count} errors, {warning_count} warnings
- Files affected: {file_count}
- Duration: {duration}

Issues found:
{list of issues with file:line and message}

Example:
src/example.ts:42:5 - error: 'variable' is never used
src/example.ts:89:12 - warning: Missing return type annotation

Cannot proceed until linting issues are resolved.
```

---

## Step 5: Exit

Return control to the calling workflow with the linting results and exit code.
