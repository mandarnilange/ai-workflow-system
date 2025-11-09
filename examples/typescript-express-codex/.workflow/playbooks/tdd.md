# TDD Cycle Playbook

**Purpose**: Enforce test-driven development (Red-Green-Refactor).

**When to use**: For EVERY implementation task (features, bugs, refactors).

---

## IMPORTANT: Read Reporting Guidelines FIRST

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

You MUST announce RED/GREEN/REFACTOR phases clearly to the user.

---

## Iron Law of TDD

```
🚫 NEVER write implementation code before writing a test
✅ ALWAYS write test first, watch it fail, then implement
```

**No exceptions.**

---

## The TDD Cycle

```
1. RED      → Write failing test
2. GREEN    → Write minimal implementation
3. REFACTOR → Improve code (optional)
4. REPEAT   → Next test
```

---

## Step 1: Write Failing Test (RED)

**Report to user BEFORE starting**:
```
🔴 RED: Writing Failing Test

Test: "{test name}"
File: {test file path}
What it tests: {brief description}

Writing test now...
```

### 1.1 Understand Requirement

Before writing test, clarify:
- What functionality is needed?
- What are inputs/outputs?
- What edge cases exist?
- What errors should be handled?

If unclear, ask user for clarification.

### 1.2 Identify Test File Location

**Convention for this project** (see `.workflow/config.yml`):
```
Test directory: {config: testing.test_directory}
Test pattern:   {config: testing.test_file_pattern}
```

Examples:
- TypeScript: `src/domain/User.ts` → `tests/domain/User.test.ts`
- Python: `src/domain/user.py` → `tests/domain/test_user.py`
- Java: `src/main/java/User.java` → `src/test/java/UserTest.java`
- Go: `internal/domain/user.go` → `internal/domain/user_test.go`

### 1.3 Write Test

**Test structure (Arrange-Act-Assert)** - examples in various languages:

**TypeScript/JavaScript (Jest)**:
```typescript
describe('Component', () => {
  it('should {expected behavior} when {condition}', () => {
    // Arrange: Set up test data and mocks
    const input = {/* test data */}

    // Act: Execute function under test
    const result = functionUnderTest(input)

    // Assert: Verify expectations
    expect(result).toBe(expected)
  })
})
```

**Python (pytest)**:
```python
def test_should_behavior_when_condition():
    # Arrange: Set up test data
    input_data = {...}

    # Act: Execute function under test
    result = function_under_test(input_data)

    # Assert: Verify expectations
    assert result == expected
```

**Java (JUnit)**:
```java
@Test
public void shouldBehaviorWhenCondition() {
    // Arrange: Set up test data
    Input input = new Input(...);

    // Act: Execute function under test
    Result result = functionUnderTest(input);

    // Assert: Verify expectations
    assertEquals(expected, result);
}
```

**Go (go test)**:
```go
func TestShouldBehaviorWhenCondition(t *testing.T) {
    // Arrange: Set up test data
    input := Input{...}

    // Act: Execute function under test
    result := FunctionUnderTest(input)

    // Assert: Verify expectations
    if result != expected {
        t.Errorf("expected %v, got %v", expected, result)
    }
}
```

**Test naming convention**:
```
"should [expected behavior] when [condition]"
```

Examples:
- "should return user when valid ID provided"
- "should throw error when user not found"
- "should handle null email gracefully"

**Test coverage checklist**:
- [ ] Happy path (normal operation)
- [ ] Edge cases (empty, null, boundaries, zero, negative)
- [ ] Error conditions (invalid input, failures, exceptions)

### 1.4 Run Test (Must FAIL)

Use the test command from config (`.workflow/config.yml`):

```bash
{config: testing.test_command}
```

Examples:
- TypeScript/JS: `npm test {test-file-path}`
- Python: `pytest tests/domain/test_user.py`
- Java: `mvn test -Dtest=UserTest`
- Go: `go test ./internal/domain/...`

**Verify test fails for the RIGHT reason**:
- ✅ Fails because feature doesn't exist yet
- ✅ Error message is: "function not defined" or "expected X but got undefined"
- ❌ NOT because of syntax errors
- ❌ NOT because of missing dependencies
- ❌ NOT because test is wrong

**If fails for wrong reason**:
- Fix syntax errors
- Install missing dependencies
- Correct test logic
- Re-run until fails for RIGHT reason

**Report to user**:
```
🔴 Test FAILED (Expected) ✅

Test: "{test name}"
File: {test file path}:{line number}

Error Message:
{show actual error}

Reason: {why it failed}

✅ This is correct - the feature doesn't exist yet.

Next: 🟢 GREEN - Write minimal implementation to make test pass
```

---

## Step 2: Write Minimal Implementation (GREEN)

**Report to user BEFORE starting**:
```
🟢 GREEN: Writing Implementation

File: {implementation file path}
What I'm adding: {brief description}

Writing minimal code to pass the test...
```

### 2.1 Write JUST ENOUGH Code

Write the **minimum code** needed to make the test pass:

**Principles**:
- ❌ NO gold plating
- ❌ NO extra features "while I'm here"
- ❌ NO premature optimization
- ❌ NO refactoring (that comes in Step 3)
- ✅ ONLY what's needed for THIS test
- ✅ Simplest solution that works

**Example of minimal implementation**:
```typescript
// Test expects: add(2, 3) === 5

// ❌ TOO MUCH:
function add(a: number, b: number): number {
  // Validate inputs
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new Error('Invalid input')
  }
  // Handle edge cases
  if (a > Number.MAX_SAFE_INTEGER || b > Number.MAX_SAFE_INTEGER) {
    throw new Error('Number too large')
  }
  // Perform calculation with optimization
  return Math.floor(a + b)
}

// ✅ MINIMAL:
function add(a: number, b: number): number {
  return a + b
}
```

### 2.2 Run Test (Must PASS)

```bash
npm test {test-file-path}
# or
npm test
```

**All tests must be green**:
- ✅ New test passes
- ✅ All existing tests still pass (no regressions)

**If not green**:
1. Review test failure message
2. Debug the implementation
3. Fix issues
4. Re-run tests
5. Repeat until all green

**If existing tests fail (regression)**:
1. Review which tests broke
2. Understand why implementation broke them
3. Adjust implementation to satisfy both new and old tests
4. Re-run until all green

**Report to user**:
```
🟢 All Tests PASSING ✅

New test: ✅ PASSING
All existing tests: ✅ PASSING ({count}/{count})
Coverage: {percentage}%

Implementation complete for this test.

Next: 🔵 REFACTOR (optional) or move to next task
```

---

## Step 3: Refactor (OPTIONAL)

**Only if needed**, improve code quality while keeping tests green.

**Report to user if refactoring**:
```
🔵 REFACTOR: Improving Code Quality

Improvements planned:
- {improvement 1}
- {improvement 2}

Refactoring now (keeping tests green)...
```

### 3.1 Identify Improvements

Look for:
- **Duplication**: Same code in multiple places
- **Poor naming**: Unclear variable/function names
- **Complex logic**: Can be simplified or extracted
- **Magic numbers**: Should be named constants
- **Long functions**: Can be broken down

### 3.2 Refactor Incrementally

**Process**:
1. Identify ONE small improvement
2. Make the change
3. Run tests: `npm test`
4. Verify still green
5. If green: Commit or continue to next improvement
6. If red: Revert change and try smaller refactoring
7. Repeat

**CRITICAL**: Keep tests green throughout refactoring.

**Examples of good refactoring**:

```typescript
// Before: Magic numbers
if (user.age >= 18) { ... }

// After: Named constant
const MINIMUM_AGE = 18
if (user.age >= MINIMUM_AGE) { ... }
```

```typescript
// Before: Duplication
function getUserName(user) {
  return user.firstName + ' ' + user.lastName
}
function getAuthorName(author) {
  return author.firstName + ' ' + author.lastName
}

// After: Extract common logic
function formatFullName(person) {
  return person.firstName + ' ' + person.lastName
}
function getUserName(user) {
  return formatFullName(user)
}
function getAuthorName(author) {
  return formatFullName(author)
}
```

### 3.3 Confirm Tests Still Green

After each refactoring change:

```bash
npm test
```

**Report to user**:
```
🟢 Tests Still GREEN After Refactor ✅

All {total} tests passing.
Coverage: {percentage}%

Refactoring successful!
Code quality improved without breaking anything.
```

**If tests fail during refactoring**:
- Revert the change: `git checkout -- {file}`
- Try smaller refactoring
- Or skip refactoring for now (can refactor later)

---

## Step 4: Repeat for Next Test

After completing Red-Green-Refactor cycle:

1. Move to next requirement/edge case
2. Write next test (go to Step 1)
3. Implement (go to Step 2)
4. Refactor (go to Step 3)
5. Repeat until feature complete

---

## Cycle Completion Checklist

After each TDD cycle, verify:

- [ ] Test was written BEFORE implementation
- [ ] Test failed initially for correct reason
- [ ] Minimal implementation was written
- [ ] All tests passing (new + existing)
- [ ] Code refactored (if needed)
- [ ] Tests still green after refactor

---

## TDD Violation Detection

### If implementation written before test:

```
⚠️ TDD VIOLATION DETECTED

You're writing implementation before the test!

This violates the Iron Law of TDD.

Please STOP and:
1. Delete or comment out the implementation
2. Write the test first
3. Run test (verify it fails)
4. THEN write implementation

Why TDD matters:
✅ Ensures testable design
✅ Prevents untested code
✅ Clarifies requirements upfront
✅ Catches regressions early
✅ Provides executable documentation
✅ Enables confident refactoring
```

**EXCEPTION: ONLY in this TDD violation case, STOP execution and wait for user acknowledgment before proceeding.**

### If test not run before implementation:

```
⚠️ Please run tests before proceeding

You wrote a test but didn't verify it fails.

Run: npm test

We need to verify the test fails for the right reason
before writing implementation.
```

### If skipping tests entirely:

```
❌ Cannot proceed without tests

TDD requires:
1. Test exists
2. Test initially failed
3. Implementation written
4. Test now passes
5. Both committed together

Writing code without tests violates project standards.
```

---

## Test Quality Checklist

Before marking test complete, verify:

- [ ] Test has clear, descriptive name
- [ ] Test follows Arrange-Act-Assert structure
- [ ] Test is isolated (no dependencies on other tests)
- [ ] Test uses mocks for external dependencies
- [ ] Test runs fast (< 1 second ideally)
- [ ] Test covers ONE specific behavior
- [ ] Test assertion is clear and specific

---

## Language-Specific Examples

### TypeScript (Jest)

```typescript
// tests/domain/User.test.ts
describe('User', () => {
  describe('constructor', () => {
    it('should create user with valid data', () => {
      // Arrange
      const userData = {
        id: '1',
        name: 'John Doe',
        email: 'john@example.com'
      }

      // Act
      const user = new User(userData)

      // Assert
      expect(user.id).toBe('1')
      expect(user.name).toBe('John Doe')
      expect(user.email).toBe('john@example.com')
    })

    it('should throw error when email is invalid', () => {
      // Arrange
      const userData = {
        id: '1',
        name: 'John Doe',
        email: 'invalid-email'
      }

      // Act & Assert
      expect(() => new User(userData)).toThrow('Invalid email')
    })
  })
})
```

### Use Case Example

```typescript
// tests/application/GetUsers.test.ts
describe('GetUsers', () => {
  it('should return all users from repository', async () => {
    // Arrange
    const mockUsers = [
      { id: '1', name: 'User 1' },
      { id: '2', name: 'User 2' }
    ]
    const mockRepository = {
      findAll: jest.fn().mockResolvedValue(mockUsers)
    }
    const useCase = new GetUsers(mockRepository)

    // Act
    const result = await useCase.execute()

    // Assert
    expect(result.success).toBe(true)
    expect(result.data).toEqual(mockUsers)
    expect(mockRepository.findAll).toHaveBeenCalledTimes(1)
  })
})
```

---

## Notes for AI Assistants

- **Enforce TDD strictly** - refuse to write code before test
- **Run tests after EVERY change** - verify green status
- **Keep cycles small** - one test, one implementation, done
- **Report status clearly** - use RED/GREEN/REFACTOR labels
- **No shortcuts** - TDD discipline prevents bugs
- **Be patient** - TDD feels slower but saves time debugging

---

## Integration with Other Playbooks

**Feature Workflow** calls this TDD playbook for each implementation task:
```
Feature → Task 1 → TDD (Red-Green-Refactor)
       → Task 2 → TDD (Red-Green-Refactor)
       → Task 3 → TDD (Red-Green-Refactor)
```

**Bugfix Workflow** calls this TDD playbook for bug fix:
```
Bugfix → Write test reproducing bug (Red)
      → Fix bug (Green)
      → Refactor (optional)
```

---

## Common TDD Mistakes to Avoid

1. ❌ Writing multiple tests before any implementation
   - ✅ One test → one implementation → repeat

2. ❌ Writing comprehensive implementation for one test
   - ✅ Minimal code to pass just this test

3. ❌ Skipping the red phase
   - ✅ Always verify test fails first

4. ❌ Refactoring without green tests
   - ✅ Only refactor when all tests pass

5. ❌ Testing implementation details
   - ✅ Test behavior and outcomes

6. ❌ Writing tests after implementation
   - ✅ Always test-first, no exceptions
