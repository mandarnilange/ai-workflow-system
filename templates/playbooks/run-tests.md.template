# Run Tests Playbook

**Purpose**: Execute the test suite with coverage reporting.

**When to use**: During pre-commit validation, or when explicitly requested to run tests.

---

## IMPORTANT: Read Reporting Guidelines FIRST

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

You MUST announce test execution progress to keep the user informed.

---

## Step 0: Announce Test Execution Start

**Report to user**:
```
🧪 Test Suite Execution

Executing: .workflow/playbooks/run-tests.md

Running test suite with coverage...
```

---

## Step 1: Load Test Configuration

Read test configuration from `.workflow/config.yml`:

```yaml
testing:
  framework: "{TEST_FRAMEWORK}"
  test_command: "{TEST_COMMAND}"
  coverage_command: "{COVERAGE_COMMAND}"
```

Use the `test_command` value from config. If not set, use default based on framework.

---

## Step 2: Execute Test Suite

Run the test command with coverage enabled:

```bash
{test_command from config} -- --coverage
```

**Examples by framework**:
- Jest: `npm test -- --coverage`
- Pytest: `pytest --cov`
- JUnit: `mvn test jacoco:report`
- Go: `go test -cover ./...`

---

## Step 3: Collect Results

Capture the following metrics:
- Exit code (0 = pass, non-zero = fail)
- Total tests run
- Tests passed
- Tests failed
- Test coverage percentage
- Any error messages or stack traces

---

## Step 4: Report Results

**If tests pass**:

**Report to user**:
```
✅ Test Suite Passed

Results:
- Tests: {passed}/{total} passed
- Coverage: {coverage_percentage}%
- Duration: {duration}

All tests completed successfully.
```

**If tests fail**:

**Report to user**:
```
❌ Test Suite Failed

Results:
- Tests: {passed}/{total} passed, {failed} failed
- Coverage: {coverage_percentage}%
- Duration: {duration}

Failed tests:
{list of failed test names and error messages}

Cannot proceed until tests pass.
```

---

## Step 5: Exit

Return control to the calling workflow with the test results and exit code.
