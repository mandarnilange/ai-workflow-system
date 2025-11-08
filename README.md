# AI Workflow System

**Universal workflow orchestration for AI-assisted development**

A language-agnostic, AI-assistant-agnostic workflow system that enforces TDD, Clean Architecture, and quality standards through markdown playbooks.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0--beta-blue.svg)](https://github.com/mandarnilange/ai-workflow-system/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Code of Conduct](https://img.shields.io/badge/code%20of%20conduct-contributor%20covenant-purple.svg)](CODE_OF_CONDUCT.md)

---

## Features

- ✅ **AI-Agnostic** - Works with Claude, ChatGPT, Gemini, Codex, Cursor, Copilot, and more

- ✅ **Language-Agnostic** - Supports TypeScript, Python, Java, Go, Rust, C#, and more

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
- **Primary AI assistant** (Claude Code, ChatGPT, Gemini, etc.)
  - If you select **Claude Code**, additional optimizations are enabled:
    - Parallel execution instructions for validators
    - Sub-agent usage recommendations
    - Performance optimization guidance

### 3. Use in Your Project

Once configured, instruct your AI assistant:

```
Please read and follow .workflow/playbooks/coordinator.md
```

That's it! The coordinator will detect intent and route to appropriate workflows.

---

## What Gets Created

After running `init.sh`, your project will have:

```
your-project/
├── .workflow/
│   ├── config.yml                    # Your project configuration
│   ├── playbooks/
│   │   ├── coordinator.md            # Master router
│   │   ├── feature.md                # Feature implementation
│   │   ├── bugfix.md                 # Bug fixing
│   │   ├── commit.md                 # Pre-commit validation
│   │   ├── tdd.md                    # TDD cycle
│   │   ├── architecture-check.md     # Architecture validation
│   │   └── reporting-guidelines.md   # Visibility rules
│   └── templates/
│       ├── feature-template.md       # .spec/ file templates
│       ├── bugfix-template.md
│       └── refactor-template.md
├── .spec/
│   └── overall-status.md             # Project dashboard
├── AGENTS.md                          # Universal AI instructions (ALL tools)
└── CLAUDE.md                          # Claude Code-specific optimizations
```

### Which File Should Your AI Assistant Use?

**For Claude Code users**: Use **`CLAUDE.md`**
- Contains Claude Code-specific optimizations
- Includes parallel execution patterns
- Optimized for Claude Code's tool system

**For ALL other AI assistants** (ChatGPT, Gemini, Codex, Cursor, Copilot, etc.): Use **`AGENTS.md`**
- Universal instructions that work with any AI tool
- Language-specific examples for your project
- Detailed workflow usage guides
- Platform-specific guidance for common issues

**If your AI tool uses a different default file** (e.g., `GEMINI.md`, `COPILOT.md`, etc.):
- Create that file in your project root
- Add a single line: `See AGENTS.md for complete instructions`
- Or copy the content from `AGENTS.md` to your tool's file

**Example - Creating GEMINI.md**:
```bash
echo "# Gemini Instructions\n\nSee AGENTS.md for complete workflow instructions." > GEMINI.md
```

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
Creating .spec/feature-user-authentication.md...
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
Running 3 validators in parallel...
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
Created .spec/fix-crash-null-email.md

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
✅ All validators PASSED

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
Updated .spec/feature-xyz.md (8/9 tasks, 89%)

## Step 2: Running Validators
Running 3 validators in parallel...
✅ Tests: 156/156 (100%)
✅ Architecture: Zero violations
✅ Linting: No issues

## Step 3: Create Git Commit
✅ Commit: ghi9012
Type: feat
Message: add user authentication endpoint

✅ Commit Complete
```

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

### 1. coordinator.md
**Purpose**: Master router - detects intent and routes to appropriate workflow
**When**: For ANY implementation work (features, bugs, refactors)

### 2. feature.md
**Purpose**: Feature implementation with TDD
**When**: Adding new functionality

### 3. bugfix.md
**Purpose**: Bug fixing with TDD
**When**: Fixing broken functionality

### 4. commit.md
**Purpose**: Pre-commit validation and git commit
**When**: Before EVERY commit (mandatory)

### 5. tdd.md
**Purpose**: Test-Driven Development cycle (Red-Green-Refactor)
**When**: Called by other playbooks during implementation

### 6. architecture-check.md
**Purpose**: Clean Architecture compliance validation
**When**: Called by commit playbook before commits

### 7. reporting-guidelines.md
**Purpose**: Enforce user visibility during workflow execution
**When**: Read by ALL playbooks to ensure proper reporting

---

## Supported Languages & Frameworks

### Languages
- TypeScript/JavaScript
- Python
- Java
- Go
- Rust
- C#
- Any language with a test framework

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

**Dependency Rule**: Dependencies must point INWARD only.

The `architecture-check.md` playbook validates this before every commit.

---

## Examples

### TypeScript/Express Example

See `examples/typescript-express/config.yml` for a complete configuration.

### Python/FastAPI Example

Coming soon: `examples/python-fastapi/config.yml`

### Java/Spring Boot Example

Coming soon: `examples/java-spring-boot/config.yml`

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
