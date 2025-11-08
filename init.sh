#!/bin/bash

# AI Workflow System - Interactive Setup Script
# MIT License

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory (parent of script directory, or specified)
TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║          AI Workflow System Setup                        ║"
echo "║          Interactive Configuration                        ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Helper function to ask questions
ask() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    if [ -n "$default" ]; then
        echo -ne "${YELLOW}${prompt} [${default}]: ${NC}"
    else
        echo -ne "${YELLOW}${prompt}: ${NC}"
    fi

    read -r input

    if [ -z "$input" ] && [ -n "$default" ]; then
        eval "$var_name=\"$default\""
    else
        eval "$var_name=\"$input\""
    fi
}

# Helper function to ask yes/no questions
ask_bool() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    local default_display
    if [ "$default" = "true" ]; then
        default_display="Y/n"
    else
        default_display="y/N"
    fi

    echo -ne "${YELLOW}${prompt} [${default_display}]: ${NC}"
    read -r input

    if [ -z "$input" ]; then
        eval "$var_name=\"$default\""
    elif [[ "$input" =~ ^[Yy] ]]; then
        eval "$var_name=\"true\""
    else
        eval "$var_name=\"false\""
    fi
}

# Helper function to select from options
ask_select() {
    local prompt="$1"
    local options="$2"
    local default="$3"
    local var_name="$4"

    echo -e "${YELLOW}${prompt}${NC}"
    IFS='|' read -ra OPTS <<< "$options"
    for i in "${!OPTS[@]}"; do
        if [ "${OPTS[$i]}" = "$default" ]; then
            echo -e "  ${GREEN}$((i+1)). ${OPTS[$i]} (default)${NC}"
        else
            echo "  $((i+1)). ${OPTS[$i]}"
        fi
    done
    echo -ne "${YELLOW}Select [1-${#OPTS[@]}]: ${NC}"
    read -r input

    if [ -z "$input" ]; then
        eval "$var_name=\"$default\""
    else
        eval "$var_name=\"${OPTS[$((input-1))]}\""
    fi
}

echo -e "\n${GREEN}=== Project Information ===${NC}\n"

ask "Project name" "My Project" PROJECT_NAME
ask "Project description" "A sample project" PROJECT_DESCRIPTION

ask_select "Programming language" "TypeScript|Python|Java|Go|Rust|C#|Other" "TypeScript" LANGUAGE
ask "Framework (e.g., Express.js, FastAPI, Spring Boot)" "Express.js" FRAMEWORK

echo -e "\n${GREEN}=== Testing Configuration ===${NC}\n"

# Set defaults based on language
case "$LANGUAGE" in
    "TypeScript")
        TEST_FRAMEWORK_DEFAULT="Jest"
        TEST_COMMAND_DEFAULT="npm test"
        COVERAGE_COMMAND_DEFAULT="npm test -- --coverage"
        TEST_DIR_DEFAULT="tests/"
        TEST_PATTERN_DEFAULT="*.test.ts"
        ;;
    "Python")
        TEST_FRAMEWORK_DEFAULT="pytest"
        TEST_COMMAND_DEFAULT="pytest"
        COVERAGE_COMMAND_DEFAULT="pytest --cov"
        TEST_DIR_DEFAULT="tests/"
        TEST_PATTERN_DEFAULT="test_*.py"
        ;;
    "Java")
        TEST_FRAMEWORK_DEFAULT="JUnit"
        TEST_COMMAND_DEFAULT="mvn test"
        COVERAGE_COMMAND_DEFAULT="mvn test jacoco:report"
        TEST_DIR_DEFAULT="src/test/"
        TEST_PATTERN_DEFAULT="*Test.java"
        ;;
    "Go")
        TEST_FRAMEWORK_DEFAULT="go test"
        TEST_COMMAND_DEFAULT="go test ./..."
        COVERAGE_COMMAND_DEFAULT="go test -cover ./..."
        TEST_DIR_DEFAULT="./"
        TEST_PATTERN_DEFAULT="*_test.go"
        ;;
    *)
        TEST_FRAMEWORK_DEFAULT=""
        TEST_COMMAND_DEFAULT=""
        COVERAGE_COMMAND_DEFAULT=""
        TEST_DIR_DEFAULT="tests/"
        TEST_PATTERN_DEFAULT="*.test.*"
        ;;
esac

ask "Test framework" "$TEST_FRAMEWORK_DEFAULT" TEST_FRAMEWORK
ask "Test command" "$TEST_COMMAND_DEFAULT" TEST_COMMAND
ask "Coverage command" "$COVERAGE_COMMAND_DEFAULT" COVERAGE_COMMAND
ask "Required test coverage (%)" "100" COVERAGE_REQUIREMENT
ask_bool "Enforce coverage requirement" "true" ENFORCE_COVERAGE
ask_bool "Require TDD (tests before code)" "true" TDD_REQUIRED
ask "Test directory" "$TEST_DIR_DEFAULT" TEST_DIR
ask "Test file pattern" "$TEST_PATTERN_DEFAULT" TEST_PATTERN

echo -e "\n${GREEN}=== Code Quality Tools ===${NC}\n"

# Set defaults based on language
case "$LANGUAGE" in
    "TypeScript")
        LINTER_DEFAULT="eslint"
        LINT_COMMAND_DEFAULT="npm run lint"
        FORMATTER_DEFAULT="prettier"
        FORMAT_COMMAND_DEFAULT="npx prettier --check ."
        TYPE_CHECKER_DEFAULT="tsc"
        TYPE_CHECK_COMMAND_DEFAULT="npx tsc --noEmit"
        ;;
    "Python")
        LINTER_DEFAULT="pylint"
        LINT_COMMAND_DEFAULT="pylint src/"
        FORMATTER_DEFAULT="black"
        FORMAT_COMMAND_DEFAULT="black --check ."
        TYPE_CHECKER_DEFAULT="mypy"
        TYPE_CHECK_COMMAND_DEFAULT="mypy src/"
        ;;
    "Java")
        LINTER_DEFAULT="checkstyle"
        LINT_COMMAND_DEFAULT="mvn checkstyle:check"
        FORMATTER_DEFAULT="google-java-format"
        FORMAT_COMMAND_DEFAULT="mvn fmt:check"
        TYPE_CHECKER_DEFAULT="null"
        TYPE_CHECK_COMMAND_DEFAULT="null"
        ;;
    "Go")
        LINTER_DEFAULT="golangci-lint"
        LINT_COMMAND_DEFAULT="golangci-lint run"
        FORMATTER_DEFAULT="gofmt"
        FORMAT_COMMAND_DEFAULT="gofmt -l ."
        TYPE_CHECKER_DEFAULT="null"
        TYPE_CHECK_COMMAND_DEFAULT="null"
        ;;
    *)
        LINTER_DEFAULT=""
        LINT_COMMAND_DEFAULT=""
        FORMATTER_DEFAULT=""
        FORMAT_COMMAND_DEFAULT=""
        TYPE_CHECKER_DEFAULT="null"
        TYPE_CHECK_COMMAND_DEFAULT="null"
        ;;
esac

ask "Linter" "$LINTER_DEFAULT" LINTER
ask "Lint command" "$LINT_COMMAND_DEFAULT" LINT_COMMAND
ask "Formatter" "$FORMATTER_DEFAULT" FORMATTER
ask "Format command" "$FORMAT_COMMAND_DEFAULT" FORMAT_COMMAND
ask_bool "Format check only (not fix)" "true" FORMAT_CHECK_ONLY
ask "Type checker (or 'null' for none)" "$TYPE_CHECKER_DEFAULT" TYPE_CHECKER
if [ "$TYPE_CHECKER" != "null" ]; then
    ask "Type check command" "$TYPE_CHECK_COMMAND_DEFAULT" TYPE_CHECK_COMMAND
else
    TYPE_CHECK_COMMAND="null"
fi

echo -e "\n${GREEN}=== Build Configuration ===${NC}\n"

ask_bool "Does project require building?" "true" BUILD_REQUIRED
if [ "$BUILD_REQUIRED" = "true" ]; then
    case "$LANGUAGE" in
        "TypeScript")
            BUILD_COMMAND_DEFAULT="npm run build"
            BUILD_OUTPUT_DIR_DEFAULT="dist/"
            ;;
        "Java")
            BUILD_COMMAND_DEFAULT="mvn package"
            BUILD_OUTPUT_DIR_DEFAULT="target/"
            ;;
        "Go")
            BUILD_COMMAND_DEFAULT="go build"
            BUILD_OUTPUT_DIR_DEFAULT="bin/"
            ;;
        *)
            BUILD_COMMAND_DEFAULT=""
            BUILD_OUTPUT_DIR_DEFAULT="build/"
            ;;
    esac
    ask "Build command" "$BUILD_COMMAND_DEFAULT" BUILD_COMMAND
    ask "Build output directory" "$BUILD_OUTPUT_DIR_DEFAULT" BUILD_OUTPUT_DIR
else
    BUILD_COMMAND="null"
    BUILD_OUTPUT_DIR="null"
fi

echo -e "\n${GREEN}=== Architecture Configuration ===${NC}\n"

ask_bool "Enforce Clean Architecture validation" "true" ARCHITECTURE_ENFORCE

echo -e "\nDefine layer paths for Clean Architecture:"
ask "  Domain layer path" "src/domain" DOMAIN_PATH
ask "  Application layer path" "src/application" APPLICATION_PATH
ask "  Infrastructure layer path" "src/infrastructure" INFRASTRUCTURE_PATH
ask "  Presentation layer path" "src/presentation" PRESENTATION_PATH
ask "  DI/Container layer path" "src/di" DI_PATH

echo -e "\n${GREEN}=== Git & Commit Configuration ===${NC}\n"

ask_bool "Run tests before commit" "true" RUN_TESTS_PRE_COMMIT
ask_bool "Run linting before commit" "true" RUN_LINTING_PRE_COMMIT
ask_bool "Run architecture validation before commit" "true" RUN_ARCHITECTURE_PRE_COMMIT

echo -e "\n${GREEN}=== Naming Conventions ===${NC}\n"

ask_select "Class file naming" "PascalCase|lowercase" "PascalCase" CLASS_FILE_CONVENTION
ask_select "Interface prefix" "I|none" "none" INTERFACE_PREFIX

case "$LANGUAGE" in
    "TypeScript"|"Java"|"C#")
        FUNCTION_CONVENTION_DEFAULT="camelCase"
        VARIABLE_CONVENTION_DEFAULT="camelCase"
        CONSTANT_CONVENTION_DEFAULT="UPPER_SNAKE_CASE"
        ;;
    "Python"|"Rust")
        FUNCTION_CONVENTION_DEFAULT="snake_case"
        VARIABLE_CONVENTION_DEFAULT="snake_case"
        CONSTANT_CONVENTION_DEFAULT="UPPER_SNAKE_CASE"
        ;;
    "Go")
        FUNCTION_CONVENTION_DEFAULT="PascalCase"
        VARIABLE_CONVENTION_DEFAULT="camelCase"
        CONSTANT_CONVENTION_DEFAULT="PascalCase"
        ;;
    *)
        FUNCTION_CONVENTION_DEFAULT="camelCase"
        VARIABLE_CONVENTION_DEFAULT="camelCase"
        CONSTANT_CONVENTION_DEFAULT="UPPER_SNAKE_CASE"
        ;;
esac

ask_select "Function naming" "camelCase|snake_case|PascalCase" "$FUNCTION_CONVENTION_DEFAULT" FUNCTION_CONVENTION
ask_select "Variable naming" "camelCase|snake_case" "$VARIABLE_CONVENTION_DEFAULT" VARIABLE_CONVENTION
ask_select "Constant naming" "UPPER_SNAKE_CASE|camelCase|PascalCase" "$CONSTANT_CONVENTION_DEFAULT" CONSTANT_CONVENTION
ask "Use case naming pattern" "VerbNoun" USE_CASE_PATTERN

echo -e "\n${GREEN}=== Task Tracking ===${NC}\n"

ask_bool "Enable .spec/ task tracking" "true" TRACKING_ENABLED

echo -e "\n${GREEN}=== AI Assistant Configuration ===${NC}\n"

ask_select "Primary AI assistant for coding" "Claude Code|Claude (Web/API)|ChatGPT|Gemini|Codex|Cursor|Other" "Claude Code" PRIMARY_AI

# Determine if using Claude Code specifically
if [ "$PRIMARY_AI" = "Claude Code" ]; then
    IS_CLAUDE_CODE="true"
    echo -e "${BLUE}✓ Claude Code detected - will configure with parallel execution and sub-agents${NC}"
else
    IS_CLAUDE_CODE="false"
fi

ask_bool "Verbose reporting (detailed progress)" "true" VERBOSE_REPORTING
ask_bool "Use emoji indicators" "true" EMOJI_INDICATORS

# Generate config.yml
echo -e "\n${BLUE}Generating configuration...${NC}"

CONFIG_FILE="$TARGET_DIR/.workflow/config.yml"
mkdir -p "$TARGET_DIR/.workflow"

cat > "$CONFIG_FILE" << EOF
# AI Workflow System Configuration
# Generated: $(date)

system:
  version: "0.1.0-beta"
  config_version: "0.1"

project:
  name: "$PROJECT_NAME"
  description: "$PROJECT_DESCRIPTION"
  language: "$LANGUAGE"
  framework: "$FRAMEWORK"

testing:
  framework: "$TEST_FRAMEWORK"
  test_command: "$TEST_COMMAND"
  coverage_command: "$COVERAGE_COMMAND"
  required_coverage: $COVERAGE_REQUIREMENT
  enforce_coverage: $ENFORCE_COVERAGE
  tdd_required: $TDD_REQUIRED
  test_directory: "$TEST_DIR"
  test_file_pattern: "$TEST_PATTERN"

quality:
  linter: "$LINTER"
  lint_command: "$LINT_COMMAND"
  formatter: "$FORMATTER"
  format_command: "$FORMAT_COMMAND"
  format_check_only: $FORMAT_CHECK_ONLY
  type_checker: "$TYPE_CHECKER"
  type_check_command: "$TYPE_CHECK_COMMAND"

build:
  required: $BUILD_REQUIRED
  command: "$BUILD_COMMAND"
  output_dir: "$BUILD_OUTPUT_DIR"

architecture:
  style: "clean"
  enforce: $ARCHITECTURE_ENFORCE
  layers:
    - name: "domain"
      path: "$DOMAIN_PATH"
      dependencies: []
    - name: "application"
      path: "$APPLICATION_PATH"
      dependencies: ["domain"]
    - name: "infrastructure"
      path: "$INFRASTRUCTURE_PATH"
      dependencies: ["domain", "application"]
    - name: "presentation"
      path: "$PRESENTATION_PATH"
      dependencies: ["domain", "application"]
    - name: "di"
      path: "$DI_PATH"
      dependencies: ["domain", "application", "infrastructure", "presentation"]

git:
  commit_style: "conventional"
  types: ["feat", "fix", "refactor", "test", "docs", "chore"]
  subject_max_length: 50
  body_max_length: 72
  run_tests_pre_commit: $RUN_TESTS_PRE_COMMIT
  run_linting_pre_commit: $RUN_LINTING_PRE_COMMIT
  run_architecture_pre_commit: $RUN_ARCHITECTURE_PRE_COMMIT

conventions:
  class_files: "$CLASS_FILE_CONVENTION"
  interface_prefix: "$INTERFACE_PREFIX"
  classes: "PascalCase"
  functions: "$FUNCTION_CONVENTION"
  variables: "$VARIABLE_CONVENTION"
  constants: "$CONSTANT_CONVENTION"
  use_case_pattern: "$USE_CASE_PATTERN"

tracking:
  enabled: $TRACKING_ENABLED
  directory: ".spec/"
  feature_prefix: "feature-"
  bugfix_prefix: "fix-"
  refactor_prefix: "refactor-"
  overall_status_file: "overall-status.md"

ai:
  primary_assistant: "$PRIMARY_AI"
  is_claude_code: $IS_CLAUDE_CODE
  verbose_reporting: $VERBOSE_REPORTING
  emoji_indicators: $EMOJI_INDICATORS

custom: {}
EOF

echo -e "${GREEN}✓ Generated: .workflow/config.yml${NC}"

# Copy playbooks
echo -e "\n${BLUE}Copying playbooks...${NC}"

mkdir -p "$TARGET_DIR/.workflow/playbooks"
mkdir -p "$TARGET_DIR/.workflow/templates"

cp -r "$SCRIPT_DIR/playbooks/"* "$TARGET_DIR/.workflow/playbooks/"
cp -r "$SCRIPT_DIR/templates/"* "$TARGET_DIR/.workflow/templates/"

echo -e "${GREEN}✓ Copied playbooks to .workflow/playbooks/${NC}"
echo -e "${GREEN}✓ Copied templates to .workflow/templates/${NC}"

# Generate AGENTS.md
echo -e "\n${BLUE}Generating AGENTS.md...${NC}"

# Determine language-specific code examples
case "$LANGUAGE" in
    "TypeScript")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="getUserById"
        EXAMPLE_TEST="User.test.ts"
        EXAMPLE_IMPORT="import { User } from './User'"
        ;;
    "Python")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="get_user_by_id"
        EXAMPLE_TEST="test_user.py"
        EXAMPLE_IMPORT="from user import User"
        ;;
    "Java")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="getUserById"
        EXAMPLE_TEST="UserTest.java"
        EXAMPLE_IMPORT="import com.example.User;"
        ;;
    "Go")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="GetUserByID"
        EXAMPLE_TEST="user_test.go"
        EXAMPLE_IMPORT="import \"example.com/domain/user\""
        ;;
    *)
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="getUser"
        EXAMPLE_TEST="user.test"
        EXAMPLE_IMPORT="import User"
        ;;
esac

cat > "$TARGET_DIR/AGENTS.md" << EOF
# AI Agent Instructions

**Universal instructions for ANY AI assistant (ChatGPT, Gemini, Codex, Claude, Cursor, etc.)**

> ⚠️ **IMPORTANT**: If you're using **Claude Code**, read **CLAUDE.md** instead for optimized instructions.
>
> **For all other AI tools**: This file (AGENTS.md) contains everything you need.

---

## Project: $PROJECT_NAME

**Language**: $LANGUAGE
**Framework**: $FRAMEWORK
**Test Framework**: $TEST_FRAMEWORK
**Architecture**: Clean Architecture (Uncle Bob's principles)

---

## Workflow System

This project uses a **language-agnostic markdown playbook system** in \`.workflow/\`.

All workflows are:
- ✅ **Tool-agnostic** - Work with any AI assistant
- ✅ **Language-agnostic** - Adapted to $LANGUAGE conventions
- ✅ **Human-readable** - Developers can follow them manually
- ✅ **Version-controlled** - Tracked in git for team consistency

---

## Quick Start Guide

### Step 1: Understand the Coordinator

For **ANY** implementation work (features, bugs, refactors), always start here:

**Read and execute**: \`.workflow/playbooks/coordinator.md\`

The coordinator playbook will:
1. ✅ Detect your intent (feature, bug fix, refactor, commit)
2. ✅ Route you to the appropriate specialized playbook
3. ✅ Guide you step-by-step through the TDD process
4. ✅ Ensure all quality gates pass

### Step 2: Example Workflow Usage

#### Example 1: Implementing a Feature

\`\`\`
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
  Understanding $FRAMEWORK authentication patterns...
  ✅ Exploration complete

  ## Step 3: TDD Implementation

  🔴 RED Phase:
  Writing failing test: "$EXAMPLE_TEST"
  Test: "should generate valid JWT token when credentials valid"
  Running: $TEST_COMMAND
  Result: FAILED ✅ (Expected - test written first)

  🟢 GREEN Phase:
  Implementing: $EXAMPLE_FUNCTION()
  Running: $TEST_COMMAND
  Result: ALL TESTS PASSING ✅

  🔵 REFACTOR Phase:
  Checking code quality...
  ✅ No refactoring needed

  ## Step 4: Validation
  Running validators in parallel:
  - Tests: $TEST_COMMAND → 156/156 PASSING ✅
  - Coverage: $COVERAGE_COMMAND → ${COVERAGE_REQUIREMENT}% ✅
  - Linting: $LINT_COMMAND → No issues ✅

  ## Step 5: Completion
  ✅ Feature complete: User authentication with JWT
  Ready to commit!
\`\`\`

#### Example 2: Fixing a Bug

\`\`\`
User: "fix null pointer error in $EXAMPLE_FUNCTION"

AI Assistant:
Step 1: Read .workflow/playbooks/coordinator.md
Step 2: Coordinator detects intent = BUGFIX
Step 3: Route to .workflow/playbooks/bugfix.md
Step 4: Execute bugfix.md:

  ## Step 1: Root Cause Analysis
  Analyzing file: $DOMAIN_PATH/$EXAMPLE_CLASS.$LANGUAGE
  Issue: Missing null check on line 45

  ## Step 2: Write Failing Test (TDD)
  🔴 RED: Test reproduces bug
  Test: "should handle null input gracefully"
  Running: $TEST_COMMAND
  Result: FAILING ✅ (Reproduces the bug)

  ## Step 3: Fix Bug
  🟢 GREEN: Adding null check
  Running: $TEST_COMMAND
  Result: ALL TESTS PASSING ✅

  ## Step 4: Validation
  ✅ All validators passed

  ✅ Bug fixed!
\`\`\`

#### Example 3: Committing Changes

\`\`\`
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
  - Tests: $TEST_COMMAND → PASSING ✅
  - Coverage: ${COVERAGE_REQUIREMENT}% → PASSING ✅
  - Linting: $LINT_COMMAND → PASSING ✅
  - Architecture: Clean Architecture check → PASSING ✅

  ## Step 3: Git Commit
  Type: feat
  Message: add user authentication with JWT tokens
  Commit: abc1234
  ✅ Committed successfully
\`\`\`

---

## How to Use This Workflow System

### For Implementation Work
When the user asks you to implement a feature, fix a bug, or refactor code:

1. **Read**: \`.workflow/playbooks/coordinator.md\`
2. **Execute**: Follow the coordinator's instructions step-by-step
3. **Report**: Announce every action BEFORE you take it

### For Commits
When the user asks you to commit changes:

1. **Read**: \`.workflow/playbooks/commit.md\`
2. **Execute**: Run all validators
3. **Commit**: Only if all validators pass

---

## ⚠️ CRITICAL: User Visibility Requirements ⚠️

**MANDATORY for ALL AI assistants**:

Before executing ANY playbook, read: **\`.workflow/playbooks/reporting-guidelines.md\`**

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
\`\`\`
🎯 Feature Workflow: User Authentication

Executing: .workflow/playbooks/feature.md

## Step 1: Initialize Task Tracking
Creating .spec/feature-user-authentication.md...
✅ Task tracking initialized

## Step 2: TDD Implementation
🔴 RED: Writing failing test...
Writing test: $EXAMPLE_TEST
Test: "should validate JWT token"
Running: $TEST_COMMAND
Result: FAILED ✅ (Expected - test written first)

🟢 GREEN: Implementing feature...
Writing: $DOMAIN_PATH/$EXAMPLE_CLASS.$LANGUAGE
Running: $TEST_COMMAND
Result: ALL TESTS PASSING ✅

## Step 3: Validation
Running 3 validators in parallel...
- Tests: $TEST_COMMAND → PASSING ✅
- Coverage: ${COVERAGE_REQUIREMENT}% → PASSING ✅
- Linting: $LINT_COMMAND → PASSING ✅
✅ All validators passed
\`\`\`

**❌ BAD - Silent execution**:
\`\`\`
[AI silently creates files, writes code, runs tests]
AI: "Done. Feature implemented. Commit abc1234"
\`\`\`

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
\`\`\`
ANNOUNCE → EXECUTE → REPORT RESULT → ANNOUNCE NEXT → EXECUTE → REPORT RESULT → ...
\`\`\`

**NOT**:
\`\`\`
EXECUTE → EXECUTE → EXECUTE → "Done"  ❌ WRONG
\`\`\`

### For ChatGPT / GPT-4

Follow reporting-guidelines.md exactly. When you see "Report to user:", output that message.

### For Codex

**Issue**: Codex may pause after each report waiting for confirmation.

**Solution**: After reporting, IMMEDIATELY continue to next action. Do NOT wait for user input.

Pattern:
\`\`\`
Report → Continue → Report → Continue → Report → Continue
\`\`\`

NOT:
\`\`\`
Report → Wait → Report → Wait  ❌ WRONG
\`\`\`

### For Claude Code

Claude Code has native support for these workflows. Follow playbooks as written.

### For Cursor / Copilot

These tools work in IDE context. Suggest commands to user when needed, but always announce what you're doing.

---

## Quick Reference

| User Request | Playbook to Read |
|--------------|------------------|
| "implement X", "add Y", "create Z" | \`.workflow/playbooks/coordinator.md\` |
| "fix bug X", "error in Y" | \`.workflow/playbooks/coordinator.md\` |
| "refactor X", "clean up Y" | \`.workflow/playbooks/coordinator.md\` |
| "commit", "save changes" | \`.workflow/playbooks/commit.md\` |

---

## Available Playbooks

Located in \`.workflow/playbooks/\`:

1. **coordinator.md** - Master router (start here for implementation work)
2. **feature.md** - Feature implementation with TDD
3. **bugfix.md** - Bug fix workflow with TDD
4. **commit.md** - Pre-commit validation and git commit
5. **tdd.md** - Test-Driven Development cycle (Red-Green-Refactor)
6. **architecture-check.md** - Clean Architecture validation
7. **reporting-guidelines.md** - Reporting requirements (READ THIS FIRST!)

**Complete documentation**: \`.workflow/README.md\`

---

## Project Configuration

All project-specific settings are in \`.workflow/config.yml\`:

- **Test command**: \`$TEST_COMMAND\`
- **Coverage command**: \`$COVERAGE_COMMAND\`
- **Required coverage**: $COVERAGE_REQUIREMENT%
- **Lint command**: \`$LINT_COMMAND\`
- **Build command**: \`$BUILD_COMMAND\`
- **TDD required**: $TDD_REQUIRED

---

## Quality Standards (Non-Negotiable)

- ✅ **${COVERAGE_REQUIREMENT}% test coverage** (statements, branches, functions, lines)
- ✅ **Zero architecture violations**
- ✅ **Zero linting errors**
- ✅ **TDD required**: $TDD_REQUIRED

---

## Architecture Rules

### Clean Architecture Dependency Rule

**Allowed Dependencies** (all dependencies point INWARD toward Domain):

- **Domain** → Nothing (pure $LANGUAGE, zero external dependencies)
- **Application** → Domain only
- **Infrastructure** → Application + Domain
- **Presentation** → Application + Domain (NEVER Infrastructure directly)
- **DI Container** → All layers (wires everything together)

### Layer Paths

\`\`\`
$DOMAIN_PATH
  ↑
$APPLICATION_PATH
  ↑
$INFRASTRUCTURE_PATH  →  $PRESENTATION_PATH
                ↑              ↑
                  $DI_PATH
\`\`\`

**CRITICAL**: Presentation layer must NEVER import from Infrastructure. Use dependency injection.

---

## Git Commit Standards

### Conventional Commits Format

\`\`\`
<type>: <subject>

<optional body>
\`\`\`

### Commit Types
- \`feat\` - New feature
- \`fix\` - Bug fix
- \`refactor\` - Code refactoring (no behavior change)
- \`test\` - Adding or updating tests
- \`docs\` - Documentation changes
- \`chore\` - Maintenance tasks

### Commit Rules
- **Subject**: imperative mood, lowercase, no period, <50 chars
- **Body**: explain WHY (not WHAT), optional, <72 chars per line
- **No AI attribution**: Do not add "Co-Authored-By: AI" or similar
- **No emoji**: Unless explicitly requested by user

### Examples

\`\`\`bash
# Good commits
feat: add jwt authentication for users
fix: handle null email in user validation
refactor: extract auth logic to domain layer

# Bad commits
feat: Added new feature  # Wrong tense
fix.  # Missing description
feat: add stuff  # Too vague
\`\`\`

---

## Common Commands

\`\`\`bash
# Testing
$TEST_COMMAND              # Run all tests
$COVERAGE_COMMAND          # Run tests with coverage report

# Code Quality
$LINT_COMMAND              # Run linter
$FORMAT_COMMAND            # Check code formatting
EOF

if [ "$TYPE_CHECKER" != "null" ]; then
cat >> "$TARGET_DIR/AGENTS.md" << EOF
$TYPE_CHECK_COMMAND        # Run type checker
EOF
fi

if [ "$BUILD_REQUIRED" = "true" ]; then
cat >> "$TARGET_DIR/AGENTS.md" << EOF

# Build
$BUILD_COMMAND             # Build the project
EOF
fi

cat >> "$TARGET_DIR/AGENTS.md" << EOF
\`\`\`

---

## Validation Checklist

Before EVERY commit, ALL of these must pass:

- [ ] **Tests**: All tests passing (\`$TEST_COMMAND\`)
- [ ] **Coverage**: ${COVERAGE_REQUIREMENT}% coverage achieved (\`$COVERAGE_COMMAND\`)
- [ ] **Linting**: Zero linting errors (\`$LINT_COMMAND\`)
EOF

if [ "$TYPE_CHECKER" != "null" ]; then
cat >> "$TARGET_DIR/AGENTS.md" << EOF
- [ ] **Type Checking**: Zero type errors (\`$TYPE_CHECK_COMMAND\`)
EOF
fi

cat >> "$TARGET_DIR/AGENTS.md" << EOF
- [ ] **Architecture**: Zero dependency violations
- [ ] **.spec/ files**: Task tracking files updated and accurate

**No exceptions**. If any validator fails, you MUST fix it before committing.

---

## Code Quality Standards

### $LANGUAGE Conventions

- **Functions**: $FUNCTION_CONVENTION (e.g., \`$EXAMPLE_FUNCTION\`)
- **Variables**: $VARIABLE_CONVENTION
- **Constants**: $CONSTANT_CONVENTION
- **Classes**: PascalCase (e.g., \`$EXAMPLE_CLASS\`)
- **Files**: $CLASS_FILE_CONVENTION

### Testing Standards

- **Framework**: $TEST_FRAMEWORK
- **Test Location**: $TEST_DIR
- **Test Pattern**: $TEST_PATTERN
- **Coverage Target**: ${COVERAGE_REQUIREMENT}%
- **TDD Required**: $TDD_REQUIRED

### Test Naming

Use descriptive test names:
\`\`\`
should [expected behavior] when [condition]
\`\`\`

Examples:
EOF

case "$LANGUAGE" in
    "TypeScript"|"JavaScript")
cat >> "$TARGET_DIR/AGENTS.md" << EOF
\`\`\`typescript
describe('$EXAMPLE_CLASS', () => {
  it('should return user when valid id provided', () => {
    // Arrange-Act-Assert
  })

  it('should throw error when user not found', () => {
    // Arrange-Act-Assert
  })
})
\`\`\`
EOF
        ;;
    "Python")
cat >> "$TARGET_DIR/AGENTS.md" << EOF
\`\`\`python
class Test$EXAMPLE_CLASS:
    def test_should_return_user_when_valid_id_provided(self):
        # Arrange-Act-Assert
        pass

    def test_should_raise_error_when_user_not_found(self):
        # Arrange-Act-Assert
        pass
\`\`\`
EOF
        ;;
    "Java")
cat >> "$TARGET_DIR/AGENTS.md" << EOF
\`\`\`java
class ${EXAMPLE_CLASS}Test {
    @Test
    void shouldReturnUserWhenValidIdProvided() {
        // Arrange-Act-Assert
    }

    @Test
    void shouldThrowExceptionWhenUserNotFound() {
        // Arrange-Act-Assert
    }
}
\`\`\`
EOF
        ;;
    "Go")
cat >> "$TARGET_DIR/AGENTS.md" << EOF
\`\`\`go
func Test${EXAMPLE_CLASS}_ShouldReturnUserWhenValidIdProvided(t *testing.T) {
    // Arrange-Act-Assert
}

func Test${EXAMPLE_CLASS}_ShouldReturnErrorWhenUserNotFound(t *testing.T) {
    // Arrange-Act-Assert
}
\`\`\`
EOF
        ;;
esac

cat >> "$TARGET_DIR/AGENTS.md" << EOF

---

## Task Tracking

All work must be tracked in \`.spec/\` directory:

- **Features**: \`.spec/feature-{name}.md\`
- **Bugs**: \`.spec/fix-{name}.md\`
- **Refactoring**: \`.spec/refactor-{name}.md\`
- **Dashboard**: \`.spec/overall-status.md\`

Templates are available in \`.workflow/templates/\`.

---

## Summary

**This project enforces quality through automated workflows**:

✅ **Test-Driven Development (TDD)** - Tests before code, always
✅ **Clean Architecture** - Strict dependency rules enforced
✅ **${COVERAGE_REQUIREMENT}% Test Coverage** - No compromises
✅ **Comprehensive Tracking** - All work tracked in .spec/
✅ **Validated Commits** - All quality gates must pass

**All workflows are in \`.workflow/playbooks/\` - just read and follow them!**

---

## For Manual Execution (Humans)

These playbooks work for human developers too:
1. Read the appropriate playbook from \`.workflow/playbooks/\`
2. Follow the steps manually
3. Run the commands in your terminal
4. Check off each completed step

The playbooks are human-readable documentation and can be followed without AI assistance.

---

## Need Help?

- Read \`.workflow/README.md\` for comprehensive documentation
- Check \`.workflow/config.yml\` for project-specific settings
- Each playbook includes detailed step-by-step instructions
- When in doubt, ask the user for clarification

---

**Remember**: Always follow the playbooks. They contain all workflow logic.
EOF

echo -e "${GREEN}✓ Generated: AGENTS.md${NC}"

# Generate CLAUDE.md
echo -e "\n${BLUE}Generating CLAUDE.md...${NC}"

cat > "$TARGET_DIR/CLAUDE.md" << EOF
# Project Instructions for Claude Code

## Workflow System

This project uses a **generic markdown playbook system** in \`.workflow/\`.

All workflows are documented in playbooks that work with any AI assistant.

---

## For ANY Implementation Work

Read and execute: **\`.workflow/playbooks/coordinator.md\`**

The coordinator will detect intent and route you to the appropriate workflow.

---

## Quick Reference

| User Request | Playbook to Execute |
|--------------|---------------------|
| "implement X" | \`.workflow/playbooks/coordinator.md\` |
| "add feature Y" | \`.workflow/playbooks/coordinator.md\` |
| "fix bug Z" | \`.workflow/playbooks/coordinator.md\` |
| "refactor W" | \`.workflow/playbooks/coordinator.md\` |
| "commit changes" | \`.workflow/playbooks/commit.md\` |

---

## Playbook System

All playbooks are in \`.workflow/playbooks/\`:

- **coordinator.md** - Master router (detects intent, routes to appropriate workflow)
- **feature.md** - Feature implementation workflow with TDD
- **bugfix.md** - Bug fix workflow with TDD
- **commit.md** - Pre-commit validation and git commit
- **tdd.md** - Test-Driven Development cycle (Red-Green-Refactor)
- **architecture-check.md** - Clean Architecture validation
- **reporting-guidelines.md** - User visibility requirements (READ FIRST!)

**Read \`.workflow/README.md\` for complete documentation.**

---

## Project Context

**Tech Stack**:
- Language: $LANGUAGE
- Framework: $FRAMEWORK
- Testing: $TEST_FRAMEWORK

**Architecture**: Clean Architecture (Uncle Bob's principles)
- $DOMAIN_PATH → $APPLICATION_PATH → $INFRASTRUCTURE_PATH → $PRESENTATION_PATH → $DI_PATH

**Quality Standards** (Non-Negotiable):
- ${COVERAGE_REQUIREMENT}% test coverage (statements, branches, functions, lines)
- Zero architecture violations
- Zero linting errors
- TDD required: $TDD_REQUIRED

---

## Code Quality Standards

### $LANGUAGE

- Functions: $FUNCTION_CONVENTION
- Variables: $VARIABLE_CONVENTION
- Constants: $CONSTANT_CONVENTION
- Class files: $CLASS_FILE_CONVENTION

### Testing

- Framework: $TEST_FRAMEWORK
- Test directory: $TEST_DIR
- Test pattern: $TEST_PATTERN
- Coverage: ${COVERAGE_REQUIREMENT}%
- TDD: $TDD_REQUIRED

### Naming Conventions

- Classes: PascalCase
- Functions: $FUNCTION_CONVENTION
- Use cases: $USE_CASE_PATTERN pattern
- Test descriptions: "should [expected behavior] when [condition]"

---

## Architecture Rules

**Dependency Rule** (dependencies point inward only):
- Domain → Nothing (pure $LANGUAGE)
- Application → Domain only
- Infrastructure → Application + Domain
- Presentation → Application + Domain (never Infrastructure directly)
- DI Container → All layers (wires everything together)

---

## Git Commit Standards

**Format**:
\`\`\`
<type>: <subject>

<optional body>
\`\`\`

**Types**: feat, fix, refactor, test, docs, chore

**Rules**:
- Subject: imperative mood, lowercase, no period, <50 chars
- Body: explain WHY (not WHAT), optional

---

## Common Commands

\`\`\`bash
$TEST_COMMAND              # Run tests
$COVERAGE_COMMAND          # Coverage report
$LINT_COMMAND              # Run linter
EOF

if [ "$BUILD_REQUIRED" = "true" ]; then
cat >> "$TARGET_DIR/CLAUDE.md" << EOF
$BUILD_COMMAND             # Build project
EOF
fi

cat >> "$TARGET_DIR/CLAUDE.md" << EOF
\`\`\`

---

## Important Notes

1. **Always use playbooks** - Don't manually orchestrate workflows
2. **TDD is mandatory** - Tests before code (if configured: $TDD_REQUIRED)
3. **${COVERAGE_REQUIREMENT}% coverage required** - No compromises
4. **Architecture compliance** - Validated before every commit
5. **Task tracking** - .spec/ files must be updated (if enabled: $TRACKING_ENABLED)

---
EOF

# Add Claude Code-specific instructions if applicable
if [ "$IS_CLAUDE_CODE" = "true" ]; then
cat >> "$TARGET_DIR/CLAUDE.md" << 'EOF'

## ⚡ Claude Code Optimizations

### Parallel Execution

**CRITICAL**: Maximize performance by running independent operations in parallel.

**Pattern**: Call multiple tools in a SINGLE message whenever possible.

#### Example: Running Validators (commit.md Step 2)

**✅ CORRECT - Parallel (FAST)**:
```
Send ONE message with THREE Bash tool calls:
1. Bash: npm test -- --coverage
2. Bash: npm run lint
3. Bash: npx tsc --noEmit
(All run concurrently)
```

**❌ WRONG - Sequential (SLOW)**:
```
Message 1: Bash: npm test -- --coverage (wait for response)
Message 2: Bash: npm run lint (wait for response)
Message 3: Bash: npx tsc --noEmit (wait for response)
(3x slower due to round trips)
```

#### Example: Reading Multiple Files

**✅ CORRECT - Parallel**:
```
Send ONE message with multiple Read tool calls:
- Read: src/domain/User.ts
- Read: src/application/GetUsers.ts
- Read: tests/domain/User.test.ts
(All read concurrently)
```

**❌ WRONG - Sequential**:
```
Read one file → wait → Read next file → wait → Read next file
```

#### When to Use Parallel Execution

1. **Validators** (commit.md Step 2) - Run tests, linting, architecture check in parallel
2. **File reads** - Reading multiple unrelated files
3. **Git operations** - `git status`, `git diff`, `git log` can run together
4. **Independent searches** - Multiple Glob/Grep operations

#### When NOT to Use Parallel

1. **Dependencies** - If operation B needs result from operation A
2. **File writes** - Write operations that might conflict
3. **Sequential logic** - When order matters

### Use Task Tool for Complex Searches

When searching for code or exploring codebase:

**✅ Use Task tool with Explore agent**:
```
User: "Where are errors from the client handled?"
Assistant: [Uses Task tool with subagent_type=Explore]
```

**❌ Don't run Grep directly** for open-ended searches:
```
❌ Grep for "error" → Grep for "client" → Read files → Grep again
(Too many round trips)
```

### Run Tests with Coverage in ONE Command

**✅ CORRECT**:
```bash
EOF

cat >> "$TARGET_DIR/CLAUDE.md" << EOF
$COVERAGE_COMMAND              # Single command gets both tests + coverage
EOF

cat >> "$TARGET_DIR/CLAUDE.md" << 'EOF'
```

**❌ WRONG**:
```bash
npm test                       # Run tests
npm test -- --coverage         # Run again for coverage (wasteful)
```

---
EOF
fi

# Continue with the rest of CLAUDE.md
cat >> "$TARGET_DIR/CLAUDE.md" << EOF

## Examples

### Example 1: User wants to add a feature
\`\`\`
User: "implement health check endpoint"

Claude:
1. Read .workflow/playbooks/coordinator.md
2. Coordinator detects intent: FEATURE
3. Routes to .workflow/playbooks/feature.md
4. Follow feature.md step-by-step
5. Report completion
\`\`\`

### Example 2: User wants to commit
\`\`\`
User: "commit these changes"

Claude:
1. Read .workflow/playbooks/commit.md
2. Follow commit.md step-by-step:
   - Update .spec/ files
   - Run validators (tests, linting, architecture)
   - Create git commit
   - Report summary
\`\`\`

### Example 3: User reports a bug
\`\`\`
User: "fix crash when email is null"

Claude:
1. Read .workflow/playbooks/coordinator.md
2. Coordinator detects intent: BUGFIX
3. Routes to .workflow/playbooks/bugfix.md
4. Follow bugfix.md step-by-step
5. Report completion
\`\`\`

---

## For More Information

See complete documentation:
- \`.workflow/README.md\` - Overview and philosophy
- \`.workflow/config.yml\` - Project configuration
- \`.workflow/playbooks/*.md\` - All workflow playbooks
- \`.workflow/templates/*.md\` - Templates for .spec/ files

---

**That's it. The playbooks contain all workflow logic. Just read and follow them.**
EOF

echo -e "${GREEN}✓ Generated: CLAUDE.md${NC}"

# Create .spec/ directory if tracking is enabled
if [ "$TRACKING_ENABLED" = "true" ]; then
    echo -e "\n${BLUE}Creating .spec/ directory...${NC}"
    mkdir -p "$TARGET_DIR/.spec"

    # Create overall-status.md
    cat > "$TARGET_DIR/.spec/overall-status.md" << EOF
# $PROJECT_NAME - Overall Status

**Last Updated**: $(date +%Y-%m-%d)

## Summary
- Total Features: 0
- Completed: 0 (0%)
- In Progress: 0
- Blocked: 0

## Active Work

### In Progress
(None)

### Recently Completed
(None)

### Blocked
(None)

## Statistics
- Test Coverage: **0% (target: ${COVERAGE_REQUIREMENT}%)**
- Open Tasks: 0
- Completed Tasks: 0

## Recent Activity
- $(date +%Y-%m-%d): Project initialized with AI Workflow System
EOF

    echo -e "${GREEN}✓ Created .spec/ directory with overall-status.md${NC}"
fi

# Create .gitignore entries
echo -e "\n${BLUE}Updating .gitignore...${NC}"

GITIGNORE_FILE="$TARGET_DIR/.gitignore"
if [ ! -f "$GITIGNORE_FILE" ]; then
    touch "$GITIGNORE_FILE"
fi

# Check if entries already exist
if ! grep -q ".workflow/config.yml" "$GITIGNORE_FILE"; then
    echo "" >> "$GITIGNORE_FILE"
    echo "# AI Workflow System" >> "$GITIGNORE_FILE"
    echo "# Note: config.yml is project-specific, commit it!" >> "$GITIGNORE_FILE"
    echo "# Uncomment next line if you want to keep config private:" >> "$GITIGNORE_FILE"
    echo "# .workflow/config.yml" >> "$GITIGNORE_FILE"
    echo -e "${GREEN}✓ Updated .gitignore${NC}"
else
    echo -e "${YELLOW}! .gitignore already contains workflow entries${NC}"
fi

# Summary
echo -e "\n${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║          Setup Complete!                                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BLUE}Created files:${NC}"
echo "  ✓ .workflow/config.yml           - Project configuration"
echo "  ✓ .workflow/playbooks/           - Workflow playbooks (7 files)"
echo "  ✓ .workflow/templates/           - Spec file templates"
echo "  ✓ AGENTS.md                      - Universal AI instructions"
echo "  ✓ CLAUDE.md                      - Claude Code instructions"
if [ "$TRACKING_ENABLED" = "true" ]; then
echo "  ✓ .spec/overall-status.md        - Task tracking dashboard"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "  1. Review .workflow/config.yml and adjust if needed"
echo "  2. Commit the workflow files to your repository"
echo "  3. Share AGENTS.md with your team"
echo "  4. Start using workflows:"
echo "     - For implementation: Ask AI to read .workflow/playbooks/coordinator.md"
echo "     - For commits: Ask AI to read .workflow/playbooks/commit.md"

echo -e "\n${BLUE}Documentation:${NC}"
echo "  - Full docs: .workflow/README.md"
echo "  - Config reference: .workflow/config.yml"
echo "  - Playbook reference: .workflow/playbooks/"

echo -e "\n${GREEN}Happy coding! 🚀${NC}\n"
