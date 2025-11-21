# AI Workflow System

**Universal workflow orchestration for AI-assisted development**

A language-agnostic, AI-assistant-agnostic workflow system that enforces TDD, Clean Architecture, and quality standards through markdown playbooks.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.7.0--beta-blue.svg)](https://github.com/mandarnilange/ai-workflow-system/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Code of Conduct](https://img.shields.io/badge/code%20of%20conduct-contributor%20covenant-purple.svg)](CODE_OF_CONDUCT.md)

---

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Updating an Existing Installation](#updating-an-existing-installation)
- [What Gets Created](#what-gets-created)
- [Claude Code Subagents](#claude-code-subagents)
- [Workflow Examples](#workflow-examples)
- [Configuration](#configuration)
- [Available Playbooks](#available-playbooks)
- [Supported Languages & Frameworks](#supported-languages--frameworks)
- [Supported AI Assistants](#supported-ai-assistants)
- [Architecture](#architecture)
- [Examples](#examples)
- [Contributing](#contributing)
- [Philosophy](#philosophy)
- [FAQ](#faq)
- [Related Documentation](#related-documentation)
- [License](#license)
- [Credits](#credits)
- [Support](#support)

---

## Features

- ✅ **AI-Agnostic** - Works with Claude, ChatGPT, Gemini, Codex, Cursor, Copilot, and more

- ✅ **Language-Agnostic** - Fully templated playbooks adapt to TypeScript, Python, Java, Go, Rust, C#, and more

- ✅ **PRD Planning** - Plan multiple features upfront with dependency tracking

- ✅ **TDD Enforced** - Red-Green-Refactor cycle with mandatory tests-first approach

- ✅ **Architecture Validation** - Clean Architecture compliance checking

- ✅ **User Visibility** - Comprehensive reporting at every step

- ✅ **Task Tracking** - Integrated `.spec/` progress tracking system

- ✅ **Configurable** - Interactive setup adapts to your tech stack

- ✅ **Git-Integrated** - Pre-commit validation with conventional commits

---

## Quick Start

### Option 1: Direct Installation from GitHub (Recommended)

Install directly without cloning:

```bash
curl -sSL https://raw.githubusercontent.com/mandarnilange/ai-workflow-system/main/install.sh | bash -s -- /path/to/your/project
```

Or for current directory:

```bash
curl -sSL https://raw.githubusercontent.com/mandarnilange/ai-workflow-system/main/install.sh | bash
```

### Option 2: Clone and Install

```bash
git clone https://github.com/mandarnilange/ai-workflow-system.git
cd ai-workflow-system
./init.sh /path/to/your/project
```

### What Happens During Setup

The interactive setup will ask about:
- Project language and framework
- Test framework and coverage requirements
- Linting and formatting tools
- Architecture layer paths
- Git commit preferences
- Naming conventions
- **Primary AI assistant** (MANDATORY - you must explicitly select)
  - No default option - you must choose from: Claude Code, ChatGPT, Gemini, Codex, Cursor, or Other
  - If you select **Claude Code**, additional features are automatically configured:
    - Parallel execution instructions for validators
    - **Three subagents** created in `.claude/agents/`:
      - `architecture-review.md` - Run architecture validation
      - `lint.md` - Run linting checks
      - `test.md` - Run test suite
    - Performance optimization guidance

### Use in Your Project

Once configured, instruct your AI assistant to read the appropriate instruction file:

**For Claude Code:**
```
Please read and follow CLAUDE.md
```

**For all other AI assistants** (ChatGPT, Gemini, Codex, Cursor, Copilot, etc.):
```
Please read and follow AGENTS.md
```

That's it! The instruction files contain:
- Complete workflow system documentation
- Language-specific code examples for your project
- Step-by-step guides for features, bugs, and commits
- Platform-specific troubleshooting tips

The workflows will automatically detect intent and route to appropriate playbooks.

---

## Updating an Existing Installation

To update your project with the latest playbooks and templates:

```bash
# Clone or pull the latest version
cd /path/to/ai-workflow-system
git pull origin main  # If you already have it cloned

# Re-run init.sh on your project
./init.sh /path/to/your/project
```

**What happens during update:**

The script will detect existing files and handle them as follows:
- ✅ **Always updated** (auto-generated system files):
  - `.workflow/playbooks/` and `.workflow/templates/` (workflow scripts)
  - `.workflow/AGENTS_INSTRUCTIONS.md` and `.workflow/CLAUDE_INSTRUCTIONS.md` (full AI instructions)
  - `AGENTS.md` and `CLAUDE.md` (pointer files)
  - `.claude/agents/` (if Claude Code is configured)
- ⚠️ **Asks before overwriting**: `.workflow/config.yml` (your project configuration)
- 🔒 **Never touched**: `.spec/` files (your work tracking), `USER_INSTRUCTIONS.md` (your custom instructions)

**Example update session:**
```
Existing Installation Detected

Found existing files:
  • .workflow/config.yml

The following will be updated automatically:
  • .workflow/playbooks/ (workflow scripts)
  • .workflow/templates/ (spec templates)
  • .workflow/AGENTS_INSTRUCTIONS.md (full universal instructions)
  • .workflow/CLAUDE_INSTRUCTIONS.md (full Claude Code instructions)
  • AGENTS.md (pointer file)
  • CLAUDE.md (pointer file)
  • .claude/agents/ (subagents - if Claude Code)

Preserved (never overwritten):
  • .spec/ (task tracking)
  • USER_INSTRUCTIONS.md (your custom instructions)

Overwrite .workflow/config.yml? (keeps your customizations if 'n') [y/N]: n
```

**Recommended approach:**
- Keep your customized `config.yml` (answer 'n')
- Let the system update all auto-generated files (happens automatically)
- Add your customizations to `USER_INSTRUCTIONS.md` instead of editing AGENTS.md or CLAUDE.md

---

## What Gets Created

After running `init.sh`, your project will have:

```
your-project/
├── .workflow/
│   ├── config.yml                      # Your project configuration
│   ├── AGENTS_INSTRUCTIONS.md          # Full universal AI instructions (auto-generated)
│   ├── CLAUDE_INSTRUCTIONS.md          # Full Claude Code instructions (auto-generated)
│   ├── playbooks/
│   │   ├── coordinator.md              # Master router
│   │   ├── prd-planning.md             # PRD multi-feature planning
│   │   ├── feature.md                  # Feature implementation
│   │   ├── bugfix.md                   # Bug fixing
│   │   ├── commit.md                   # Pre-commit validation
│   │   ├── tdd.md                      # TDD cycle
│   │   ├── architecture-check.md       # Architecture validation
│   │   ├── run-tests.md                # Test execution
│   │   ├── run-lint.md                 # Linting execution
│   │   └── reporting-guidelines.md     # Visibility rules
│   └── templates/
│       ├── feature-template.md         # .spec/ file templates
│       ├── bugfix-template.md
│       ├── prd-template.md             # PRD planning template
│       └── refactor-template.md
├── .claude/                             # Claude Code specific (if selected)
│   └── agents/
│       ├── architecture-review.md      # Subagent: architecture validation
│       ├── lint.md                     # Subagent: linting checks
│       └── test.md                     # Subagent: test execution
├── .spec/
│   ├── .sequence                        # Sequence counter (auto-managed)
│   ├── overall-status.md               # Project dashboard
│   ├── 001-feature-xxx.md              # Feature specs (sequenced)
│   ├── 002-fix-xxx.md                  # Bug fix specs (sequenced)
│   └── 003-feature-yyy.md              # More specs...
├── AGENTS.md                            # Pointer to .workflow/AGENTS_INSTRUCTIONS.md (auto-generated)
├── CLAUDE.md                            # Pointer to .workflow/CLAUDE_INSTRUCTIONS.md (auto-generated)
└── USER_INSTRUCTIONS.md                 # Your custom instructions (never overwritten)
```

**Note on `.spec/` Sequence Numbering:**
- All spec files are prefixed with a 3-digit sequence number (001, 002, 003, etc.)
- The `.spec/.sequence` file tracks the next number to use
- Sequence numbers are shared across all types (features, fixes, refactors)
- This provides chronological ordering of all work items
- The `.sequence` file should be committed to maintain consistency across the team

Examples:
- `001-feature-health-endpoint.md` - First work item
- `002-fix-crash-null-email.md` - Second work item
- `003-feature-authentication.md` - Third work item
```

### Which File Should Your AI Assistant Use?

**For Claude Code users**: Use **`CLAUDE.md`**
- Pointer file that references `.workflow/CLAUDE_INSTRUCTIONS.md` (full instructions)
- Also reads `USER_INSTRUCTIONS.md` (your custom instructions)
- Contains Claude Code-specific optimizations and subagent usage
- Includes parallel execution patterns

**For ALL other AI assistants** (ChatGPT, Gemini, Codex, Cursor, Copilot, etc.): Use **`AGENTS.md`**
- Pointer file that references `.workflow/AGENTS_INSTRUCTIONS.md` (full instructions)
- Also reads `USER_INSTRUCTIONS.md` (your custom instructions)
- Universal instructions that work with any AI tool
- Language-specific examples for your project
- Detailed workflow usage guides

**Important Notes:**
- `AGENTS.md` and `CLAUDE.md` are auto-generated pointer files (always overwritten during updates)
- Full instructions live in `.workflow/AGENTS_INSTRUCTIONS.md` and `.workflow/CLAUDE_INSTRUCTIONS.md`
- Add your custom instructions to `USER_INSTRUCTIONS.md` (never overwritten by updates)

**If your AI tool uses a different default file** (e.g., `GEMINI.md`, `COPILOT.md`, etc.):
- Create that file in your project root
- Add a single line: `See AGENTS.md for complete instructions`
- Or copy the content from `AGENTS.md` to your tool's file

**Example - Creating GEMINI.md**:
```bash
echo "# Gemini Instructions\n\nSee AGENTS.md for complete workflow instructions." > GEMINI.md
```

---

## Claude Code Subagents

If you selected **Claude Code** during initialization, the system automatically creates three subagents in `.claude/agents/`. These provide quick access to common validation tasks:

### Available Subagents

1. **`architecture-review.md`** - Validates Clean Architecture compliance
   - References: `.workflow/playbooks/architecture-check.md`
   - Checks dependency rules across layers

2. **`lint.md`** - Runs static analysis and linting
   - References: `.workflow/playbooks/run-lint.md`
   - Executes configured linter (ESLint, Pylint, etc.)

3. **`test.md`** - Executes test suite with coverage
   - References: `.workflow/playbooks/run-tests.md`
   - Runs tests and reports coverage

### How Subagents Work

Each subagent is defined using Claude Code's standard agent format with YAML frontmatter and a system prompt:

```markdown
---
name: test
description: Execute the test suite with coverage reporting
---

You are a test execution specialist ensuring code quality through comprehensive testing.

When invoked, read and execute the playbook at `.workflow/playbooks/run-tests.md`.

This playbook will guide you through:
1. Loading test configuration from .workflow/config.yml
2. Executing the test suite with coverage
3. Collecting test results and coverage metrics
4. Reporting pass/fail status and coverage percentages

Follow the playbook exactly and report all findings to the user.
```

**Key components:**
- **name**: Unique identifier for the subagent
- **description**: Brief description of when this subagent should be invoked
- **System prompt**: Defines the subagent's role and points to the corresponding playbook. Can be multiple paragraphs with specific instructions, best practices, and constraints.

This design keeps validation logic centralized in playbooks while providing Claude Code-native subagents for easy invocation.

### Using Subagents

**Viewing available subagents:**
```
/agents
```

This shows all available subagents including the three validation subagents created during initialization.

**Manual invocation:**
You can explicitly request a specific subagent:
```
> Use the test subagent to run the test suite
> Use the lint subagent to check code quality
> Use the architecture-review subagent to validate dependencies
```

**During commit workflow:**
When executing `.workflow/playbooks/commit.md`, the playbook instructs Claude Code to read and execute the three subagent files in parallel for comprehensive validation.

---

## Workflow Examples

### Implementing a Feature

```
User: "implement user authentication endpoint"

AI:
🎯 Workflow Coordinator
Detected Intent: FEATURE
Routing to: .workflow/playbooks/feature.md

## Step 1: Initialize Task Tracking
Creating .spec/001-feature-user-authentication.md...
✅ Step 1 Complete

## Step 2: Exploration & Planning
Understanding existing codebase...
✅ Step 2 Complete

## Step 3: TDD Implementation

🔴 RED: Writing Failing Test
Test: "should return 401 when credentials invalid"
Running test... FAILED ✅ (expected)

🟢 GREEN: Writing Implementation
Adding authentication logic...
Running tests... ALL PASSING ✅ (156/156)

## Step 4: Validation
Running 3 validators in parallel:
- .workflow/playbooks/run-tests.md
- .workflow/playbooks/run-lint.md
- .workflow/playbooks/architecture-check.md

✅ Tests: 156/156 (100% coverage)
✅ Architecture: Zero violations
✅ Linting: No issues

## Step 5: Commit
✅ Commit: abc1234

✅ Feature Complete: User Authentication Endpoint
```

### Fixing a Bug

```
User: "fix crash when email is null"

AI:
🎯 Workflow: Bugfix
Routing to: .workflow/playbooks/bugfix.md

## Step 1: Initialize Bug Tracking
Created .spec/002-fix-crash-null-email.md

## Step 2: Root Cause Analysis
File: src/domain/User.ts:45
Issue: Missing null check on email field

## Step 3: Write Failing Test (TDD)
🔴 RED: Test reproduces bug
Test: "should handle null email gracefully"
Status: FAILING ✅ (reproduces crash)

## Step 4: Fix Bug
🟢 GREEN: Bug fixed
All tests: 156/156 PASSING ✅

## Step 5: Validation
Running 3 validators in parallel:
- .workflow/playbooks/run-tests.md
- .workflow/playbooks/run-lint.md
- .workflow/playbooks/architecture-check.md

✅ Tests: 156/156 (100% coverage)
✅ Architecture: Zero violations
✅ Linting: No issues

## Step 6: Commit
✅ Commit: def5678

✅ Bug Fixed: Crash on Null Email
```

### Committing Changes

```
User: "commit these changes"

AI:
🎯 Commit Workflow

## Step 1: Update Task Tracking
Updated .spec/003-feature-xyz.md (8/9 tasks, 89%)

## Step 2: Running Validators
Running 3 validators in parallel:
- .workflow/playbooks/run-tests.md
- .workflow/playbooks/run-lint.md
- .workflow/playbooks/architecture-check.md

✅ Tests: 156/156 (100% coverage)
✅ Architecture: Zero violations
✅ Linting: No issues

## Step 3: Create Git Commit
✅ Commit: ghi9012
Type: feat
Message: add user authentication endpoint

✅ Commit Complete
```

### Planning a PRD with Multiple Features

```
User: "plan a PRD with 3 features: user authentication, product catalog, shopping cart.
Product catalog depends on user auth. Shopping cart depends on both."

AI:
🎯 Workflow Coordinator
Detected Intent: PLAN
Routing to: .workflow/playbooks/prd-planning.md

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

[User confirms: "yes"]

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

✅ Updated: .spec/overall-status.md

Dashboard Summary:
- Total Features: 3
- Pending: 3 (newly added)
- In Progress: 0
- Completed: 0

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

Next Steps:
1. Review spec files in .spec/ directory
2. Add more detail to feature descriptions if needed
3. Start implementation with: "Implement feature 001"

Recommended first implementation:
- User Authentication (.spec/001-feature-user-authentication.md)
```

**What happens after planning:**
- Each feature has its own spec file (Status: Pending)
- You can implement features in any order
- Use: `"Implement feature 001"` to start TDD workflow
- Feature status updates: Pending → In Progress → Completed

**PRD Template Available:**
See `templates/prd-template.md` for a structured PRD format (optional).

---

## Configuration

All project-specific settings are in `.workflow/config.yml`:

```yaml
project:
  name: "My Project"
  language: "TypeScript"
  framework: "Express.js"

testing:
  framework: "Jest"
  test_command: "npm test"
  coverage_command: "npm test -- --coverage"
  required_coverage: 100
  tdd_required: true

quality:
  linter: "eslint"
  lint_command: "npm run lint"

architecture:
  style: "clean"
  enforce: true
  layers:
    - name: "domain"
      path: "src/domain"
      dependencies: []
    - name: "application"
      path: "src/application"
      dependencies: ["domain"]
    # ... more layers
```

Edit this file to customize for your project.

---

## Available Playbooks

All playbooks are located in `.workflow/playbooks/`. **Note**: You don't need to reference these directly - `AGENTS.md` and `CLAUDE.md` contain all the instructions your AI assistant needs.

### 1. coordinator.md
**Purpose**: Master router - detects intent and routes to appropriate workflow
**When**: Automatically invoked by AGENTS.md/CLAUDE.md for ANY implementation work (features, bugs, refactors, PRD planning)

### 2. prd-planning.md
**Purpose**: Plan and create spec files for multiple features from a PRD
**When**: Planning multiple features upfront (without implementing them)
**Keywords**: "plan", "PRD", "spec", "outline", "breakdown", "prepare features"

### 3. feature.md
**Purpose**: Feature implementation with TDD
**When**: Adding new functionality

### 4. bugfix.md
**Purpose**: Bug fixing with TDD
**When**: Fixing broken functionality

### 5. commit.md
**Purpose**: Pre-commit validation and git commit
**When**: Before EVERY commit (mandatory)

### 6. tdd.md
**Purpose**: Test-Driven Development cycle (Red-Green-Refactor)
**When**: Called by other playbooks during implementation

### 7. architecture-check.md
**Purpose**: Clean Architecture compliance validation
**When**: Called by commit playbook before commits

### 8. run-tests.md
**Purpose**: Execute test suite with coverage reporting
**When**: Called by commit playbook, or via Claude Code subagents

### 9. run-lint.md
**Purpose**: Run static analysis and linting checks
**When**: Called by commit playbook, or via Claude Code subagents

### 10. reporting-guidelines.md
**Purpose**: User visibility and reporting rules
**When**: Referenced by all playbooks to ensure step-by-step communication

---

## Supported Languages & Frameworks

### How Language Support Works

The workflow system uses **templated playbooks** that automatically adapt to your chosen language during initialization:

- **Architecture validation** uses language-specific file patterns (`.ts`, `.py`, `.java`, etc.)
- **Import checking** uses language-appropriate regex patterns
- **Code examples** in playbooks match your language syntax
- **Commands** pull from config.yml (test, lint, build commands)

**Result**: Whether you select TypeScript, Python, Java, Go, Rust, or C#, the generated playbooks will use correct file extensions, import patterns, and validation logic for that language.

### Fully Supported Languages
- **TypeScript/JavaScript** - `.ts` files, ESLint, Jest, npm
- **Python** - `.py` files, pylint/black, pytest, pip
- **Java** - `.java` files, Checkstyle, JUnit, Maven
- **Go** - `.go` files, golangci-lint, go test
- **Rust** - `.rs` files, cargo test
- **C#** - `.cs` files, ASP.NET Core
- **Any language** with a test framework (generic defaults provided)

### Frameworks
- Express.js, Fastify (Node.js)
- FastAPI, Django, Flask (Python)
- Spring Boot (Java)
- Gin, Echo (Go)
- Actix, Rocket (Rust)
- ASP.NET Core (C#)
- Any framework compatible with Clean Architecture

---

## Supported AI Assistants

This workflow system works with:

- ✅ **Claude Code** - Native support
- ✅ **ChatGPT** - Via AGENTS.md instructions
- ✅ **Google Gemini** - Via AGENTS.md instructions
- ✅ **GitHub Copilot** - Via AGENTS.md instructions
- ✅ **Cursor** - Via IDE integration
- ✅ **Codex** - Via AGENTS.md instructions
- ✅ **Manual Execution** - Humans can follow playbooks too!

---

## Architecture

This system enforces **Clean Architecture** (Uncle Bob):

```
┌─────────────────────────────────────┐
│   Frameworks & Drivers              │
│   (Web, DB, UI, Devices, etc.)      │
└─────────────────────────────────────┘
      ▲                               
      │                               
┌─────────────────────────────────────┐
│   Interface Adapters                │
│   (Controllers, Presenters, Gateways)│
└─────────────────────────────────────┘
      ▲                               
      │                               
┌─────────────────────────────────────┐
│   Application (Use Cases)           │
│   (Application Business Rules)      │
└─────────────────────────────────────┘
      ▲                               
      │                               
┌─────────────────────────────────────┐
│   Domain (Entities/Interfaces)      │
│   (Enterprise Business Rules)       │
└─────────────────────────────────────┘
```

**Dependency Rule**: Dependencies must point INWARD only. Each layer can only depend on the layers immediately inside it.

The `architecture-check.md` playbook validates this before every commit.

---

## Examples

This repository includes working example projects demonstrating the workflow system in action:

### TypeScript/Express.js Example

**Location**: `examples/typescript-express/`

A complete TypeScript/Express.js project with:
- Health check endpoint implementation
- Full TDD workflow (tests written first)
- Clean Architecture structure
- 100% test coverage
- Complete `.workflow/` configuration

**Files**:
- `config.yml` - Complete workflow configuration for TypeScript/Express
- `README.md` - Project-specific documentation

### TypeScript/Express.js with Gemini

**Location**: `examples/typescript-express-gemini/`

Same as above, configured and tested specifically with Google Gemini AI:
- Demonstrates Gemini-specific workflow patterns
- Includes `GEMINI.md` instruction file
- Shows platform-specific troubleshooting

### More Examples Coming Soon

- Python/FastAPI - `examples/python-fastapi/`
- Java/Spring Boot - `examples/java-spring-boot/`
- Go/Gin - `examples/go-gin/`

**Want to contribute an example?** See [CONTRIBUTING.md](CONTRIBUTING.md)!

---

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

**Quick contribution guide:**

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Follow** the workflow system (yes, we use it on itself!)
4. **Test** on at least 2 languages
5. **Commit** using conventional commits (`git commit -m 'feat: add amazing feature'`)
6. **Push** to your branch (`git push origin feature/amazing-feature`)
7. **Open** a Pull Request

**Ways to contribute:**
- 🐛 Report bugs via [Issues](https://github.com/mandarnilange/ai-workflow-system/issues)
- ✨ Suggest features via [Discussions](https://github.com/mandarnilange/ai-workflow-system/discussions)
- 🌍 Add support for new languages
- 📖 Improve documentation
- 🧪 Add more examples
- 🎯 Create new playbooks

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

---

## Philosophy

### Why Markdown Playbooks?

- **AI-Native**: LLMs understand markdown naturally
- **Human-Readable**: Developers can read and understand workflows
- **Version Controllable**: Track workflow changes in git
- **Language-Agnostic**: Not tied to any programming language
- **Tool-Agnostic**: Works with any AI assistant

### Why Enforce TDD?

- **Quality**: Tests document behavior and catch regressions
- **Design**: Writing tests first improves API design
- **Confidence**: High test coverage enables fearless refactoring
- **Speed**: TDD is faster than debug-driven development

### Why Clean Architecture?

- **Maintainability**: Clear boundaries between layers
- **Testability**: Easy to test each layer independently
- **Flexibility**: Easy to swap implementations (e.g., change database)
- **Scalability**: Architecture scales with team size

---

## FAQ

### Q: Does this work with my language/framework?
**A**: Yes! The init script supports TypeScript, Python, Java, Go, Rust, C#, and can be configured for any language.

### Q: Can I use this without AI assistants?
**A**: Yes! Humans can follow the playbooks manually. They serve as excellent workflow documentation.

### Q: Do I need 100% test coverage?
**A**: Coverage requirement is configurable. Set `testing.required_coverage` in config.yml.

### Q: What if I don't use Clean Architecture?
**A**: Set `architecture.enforce: false` in config.yml to disable architecture validation.

### Q: Can I customize the playbooks?
**A**: Yes! After initialization, edit `.workflow/playbooks/` files to customize workflows.

### Q: How do I update to the latest version?
**A**: Pull latest changes, run `./init.sh` again, and review/merge config changes.

---

## Related Documentation

### Comparison with GitHub Spec-Kit

Wondering how this system compares to GitHub's spec-kit? See our detailed comparison:

**📄 [AI Workflow System vs GitHub Spec-Kit](docs/comparison-with-spec-kit.md)** *(Updated for v0.7.0 - Language-Agnostic Architecture)*

**TL;DR**:
- **Spec-Kit**: Focuses on **specification quality** (requirements validation, constitution pattern)
- **AI Workflow System**: Provides **end-to-end workflow** with language-agnostic templating - PRD planning with dependency analysis → TDD implementation → architecture validation → quality gates
- **Both Approaches Work**: Use AI Workflow System alone for integrated planning + implementation, OR use both for maximum quality

**Key Technical Advantages** (v0.7.0):
- ✅ **Language-Agnostic Templating**: All playbooks use variable substitution - adapts to TypeScript, Python, Java, Go, Rust, C# automatically
- ✅ **Architecture Validation**: Language-aware (correct file extensions, import patterns per language)
- ✅ **PRD Planning**: Dependency analysis + implementation order recommendations
- ✅ **TDD Enforcement**: Mandatory tests-first (Spec-Kit doesn't enforce)
- ✅ **Quality Gates**: Pre-commit validators (tests + arch + lint)
- ✅ **Integrated Workflow**: Seamless planning → implementation transition

**Recommendations**:
- **AI Workflow System alone**: For most projects (planning + quality enforcement in one system)
- **Both together**: For enterprise projects requiring specification validation + implementation quality
- **Spec-Kit alone**: For specification-only work (rare)

See the [full comparison document](docs/comparison-with-spec-kit.md) for detailed analysis, use cases, and migration paths.

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Credits

Created to solve the problem of inconsistent AI-assisted development workflows across teams and projects.

Inspired by:
- Clean Architecture (Robert C. Martin)
- Test-Driven Development (Kent Beck)
- Conventional Commits

---

## Support

- 📖 **Documentation**: This README + [CHANGELOG](CHANGELOG.md)
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/mandarnilange/ai-workflow-system/issues)
- 💬 **Questions**: [GitHub Discussions](https://github.com/mandarnilange/ai-workflow-system/discussions)
- 🔒 **Security**: See [SECURITY.md](SECURITY.md)
- 🤝 **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)

### Community

- ⭐ Star this repo to show support
- 🔔 Watch for updates and releases
- 🐦 Share with your team
- 📣 Spread the word about AI-assisted development workflows

---

**Happy coding!** 🚀
