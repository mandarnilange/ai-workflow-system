# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for 1.0.0
- Integration testing with real Python/Java/Go projects
- Example projects for each supported language (Python, Java, Go, Rust, C#)
- Real-world beta testing with 3-5 teams per language
- CI/CD integration examples (GitHub Actions, GitLab CI)
- Production hardening based on beta feedback
- Additional language support (Ruby, PHP, Kotlin, Swift)

---

## [0.7.0-beta] - 2025-01-21

### 🚀 Major Features - Language-Agnostic Architecture

#### Added
- **Language-Agnostic Playbook Templating System**
  - All 10 playbooks converted to templates with variable substitution
  - Playbooks now adapt to TypeScript, Python, Java, Go, Rust, C# automatically
  - Language-specific file extensions (`.ts`, `.py`, `.java`, `.go`, `.rs`, `.cs`)
  - Language-specific import patterns for architecture validation
  - Language-specific code examples in playbooks

- **Architecture Validation Improvements**
  - Language-aware file pattern matching (`${FIND_FILES_PATTERN}`)
  - Language-specific import regex patterns (`${IMPORT_PATTERN}`, `${IMPORT_FROM_PATTERN}`)
  - Correct source directory detection per language (`${SOURCE_DIR}`)
  - Template variables: `${FILE_EXTENSION}`, `${LANGUAGE_LOWER}`, `${EXAMPLE_IMPORT}`, `${EXAMPLE_CLASS}`, `${EXAMPLE_FUNCTION}`

- **Init Script Enhancements**
  - Language-specific variable definitions for 6 languages
  - Template processing with `envsubst` for all playbooks
  - `LANGUAGE_LOWER` variable for syntax highlighting in code blocks
  - Enhanced `process_template()` function with architecture validation variables

#### Added (XP & Guidelines)
- **XP Principles & Core Philosophy**
  - Added "Core Philosophy" section to `AGENTS_INSTRUCTIONS.md`
  - Enforced Simplicity, Feedback, Courage, and Respect values
- **Testing Rigor**
  - Added mandatory "Identify Edge Cases" step to TDD playbook
  - Updated testing standards to strictly require edge case coverage
- **Iterative Planning**
  - Updated `prd-planning.md` to enforce iterative phases (Walking Skeleton, MVP, Enhancements)
#### Changed
- **Directory Structure Simplified**
  - Moved all playbooks from `playbooks/*.md` to `templates/playbooks/*.template`
  - Removed `playbooks/` directory entirely (single source of truth)
  - All playbooks now processed through template system (even if no variables)

- **Playbook Updates**
  - `architecture-check.md`: Now uses language-specific patterns throughout
  - `feature.md`: Uses `${TYPE_CHECK_CHECKLIST}`, `${COVERAGE_COMMAND}`, `${LINT_COMMAND}`
  - `bugfix.md`: Uses `${TEST_COMMAND}`, `${COVERAGE_COMMAND}`, `${LINT_COMMAND}`, `${TYPE_CHECK_CHECKLIST}`
  - All 10 playbooks: Converted to `.template` format

- **Documentation**
  - README.md: Added Table of Contents, updated to 0.7.0-beta
  - README.md: Enhanced "Supported Languages & Frameworks" section explaining templating
  - README.md: Updated Spec-Kit comparison with language-agnostic features
  - docs/comparison-with-spec-kit.md: Updated to v1.1 with language-agnostic architecture details

#### Fixed
- **Critical Issue**: Removed hardcoded TypeScript patterns from playbooks (#critical-language-agnostic-issue)
- **Critical Issue**: Architecture validation now works for Python, Java, Go, Rust, C#
- **Critical Issue**: Import checking uses correct regex per language
- Removed hardcoded "Zero TypeScript errors" from feature.md and bugfix.md checklists

### 🔧 Technical Details

#### Template Variables Added
```bash
FILE_EXTENSION          # .ts, .py, .java, .go, .rs, .cs
TEST_FILE_EXTENSION     # .test.ts, _test.py, Test.java, _test.go, .rs, Tests.cs
SOURCE_DIR              # src, src/main/java, etc.
IMPORT_PATTERN          # Language-specific import regex
IMPORT_FROM_PATTERN     # Language-specific relative import regex
FIND_FILES_PATTERN      # *.ts, *.py, *.java, etc.
LANGUAGE_LOWER          # typescript, python, java, go, rust, c#
EXAMPLE_IMPORT          # Language-specific import example
EXAMPLE_CLASS           # Language-specific class syntax
EXAMPLE_FUNCTION        # Language-specific function syntax
```

#### Language Support Matrix
| Language   | File Ext | Import Pattern        | Test Pattern    | Status |
|------------|----------|-----------------------|-----------------|--------|
| TypeScript | `.ts`    | `^import`            | `*.test.ts`     | ✅ Full |
| Python     | `.py`    | `^(import\|from)`    | `test_*.py`     | ✅ Full |
| Java       | `.java`  | `^import`            | `*Test.java`    | ✅ Full |
| Go         | `.go`    | `^import`            | `*_test.go`     | ✅ Full |
| Rust       | `.rs`    | `^use`               | `*.rs`          | ✅ Full |
| C#         | `.cs`    | `^using`             | `*Tests.cs`     | ✅ Full |

### 🔄 Migration & Compatibility
- **Backward Compatible**: Quick update mode preserves existing config.yml
- **Automatic Migration**: Running `./init.sh` regenerates playbooks with language-specific content
- **No Breaking Changes**: User workflow remains the same

### 📊 Metrics
- **10 playbooks** converted to templates
- **6 languages** fully supported with language-specific patterns
- **9 new template variables** for language adaptation
- **0 breaking changes** to user workflow

### 🎯 What's Next (Path to 1.0)
- Integration testing with real Python/Java/Go projects
- Example projects for each supported language
- Real-world beta testing with 3-5 teams per language
- CI/CD integration examples
- Performance optimization

### 🙏 Acknowledgments
- Review feedback from AI_WORKFLOW_REVIEW.md addressing critical language-agnostic issues
- Community feedback on TypeScript-only limitations

---

## [0.6.0-beta] - 2025-11-12

### Added
- **PRD Planning Capability**: Comprehensive PRD planning workflow for multi-feature projects
  - New PRD Planning playbook (`playbooks/prd-planning.md`)
    - Plan multiple features from PRD input (any format)
    - Automatic dependency analysis and phase recommendations
    - Creates `.spec/` files with Status: Pending
    - Updates `overall-status.md` dashboard
    - Seamless transition to implementation workflow
  - New PRD template (`templates/prd-template.md`)
    - Optional structured PRD format
    - Includes project overview, features, constraints
    - Complete e-commerce MVP example
  - Coordinator updates (`playbooks/coordinator.md`)
    - Added PLAN intent detection
    - Keywords: "plan", "PRD", "spec", "outline", "breakdown"
    - Routes to prd-planning.md before FEATURE check
    - Updated clarification options and examples

- **Documentation**: Comprehensive comparison with GitHub Spec-Kit
  - New comparison document (`docs/comparison-with-spec-kit.md`)
  - 31-row detailed comparison table (planning, implementation, tracking)
  - Philosophical differences and use case analysis
  - Three-tier recommendation structure
  - Migration paths and integration approaches
  - Positions AI Workflow System as complete standalone solution

### Changed
- **README.md Updates**: Enhanced with PRD planning documentation
  - Added PRD Planning to features list
  - New workflow example: Planning a PRD with Multiple Features
  - Updated playbooks list (1-10 numbered)
  - Updated directory structure
  - Added Related Documentation section with Spec-Kit comparison
  - Three-tier recommendation for users

### Improved
- **Workflow Enhancement**: Addressed limitation of single-feature-at-a-time workflow
  - Users can now plan entire PRDs upfront before implementation
  - Automatic dependency analysis with implementation order recommendations
  - Seamless planning → implementation workflow in single system
  - Competitive with GitHub Spec-Kit for PRD planning while maintaining superior implementation quality enforcement (TDD + Clean Architecture)

### Workflow Example
1. "Plan PRD with features A, B, C" → creates `.spec/001-003` (Pending)
2. "Implement feature 001" → TDD workflow → Completed
3. Repeat for remaining features

---

## [0.5.0-beta] - 2025-01-11

### Added
- **Template System**: Extracted all instruction content from init.sh into reusable template files
  - Created `templates/instructions/` for all instruction files
  - Created `templates/agents/` for Claude Code subagent definitions
  - Reduced init.sh from 2083 lines to 894 lines (57% reduction)
  - Added `process_template()` function using `envsubst` for variable substitution
  - Benefits: Much easier to maintain, version control, and customize instructions

### Changed
- **MANDATORY WORKFLOW ENFORCEMENT**: Added emphatic warnings to all instruction files
  - Added prominent "MANDATORY WORKFLOW" section at top of all instruction files
  - Clear FORBIDDEN vs REQUIRED sections
  - Explicit "Direct implementation without workflow = FAILURE" message
  - Added execution pattern examples (correct vs wrong)
  - Updated both pointer files (AGENTS.md, CLAUDE.md) and full instruction files

- **Continuous Execution Guidance**: Clarified that AI agents should NOT pause between steps
  - Added "Execute CONTINUOUSLY" requirement to all instructions
  - Added execution pattern diagrams showing correct continuous flow
  - Enhanced Codex-specific guidance with 5 explicit rules and self-check question
  - Clarified "step-by-step" means announce then execute, not wait for confirmation

- **File Structure**: Reorganized instruction file architecture
  - `.workflow/AGENTS_INSTRUCTIONS.md` - Full universal AI instructions (auto-generated)
  - `.workflow/CLAUDE_INSTRUCTIONS.md` - Full Claude Code instructions (auto-generated)
  - `AGENTS.md` - Pointer file with mandatory workflow warnings (auto-generated)
  - `CLAUDE.md` - Pointer file with mandatory workflow warnings (auto-generated)
  - `USER_INSTRUCTIONS.md` - User customizations (never overwritten)

### Improved
- **Documentation**: Updated README.md to reflect new template-based architecture
- **Maintainability**: Template system makes updates significantly easier
- **Clarity**: Stronger, more explicit guidance prevents AI agents from skipping workflows or pausing unnecessarily

---

## [0.4.0-beta] - 2025-11-09

### Fixed
- **Codex Auto-Continue Issue**: Fixed workflow pause behavior that caused Codex to stop after each report
  - Updated all playbooks to explicitly specify auto-continue behavior
  - Added "IMMEDIATELY AND AUTOMATICALLY" instructions to prevent pauses
  - Clarified only 4 cases where waiting for user input is appropriate:
    1. When intent is UNCLEAR (coordinator.md)
    2. When requirements are UNCLEAR (feature.md)
    3. When validators FAIL (commit.md)
    4. When TDD violation detected (tdd.md)
  - Updated files:
    - `.workflow/playbooks/coordinator.md`
    - `.workflow/playbooks/feature.md`
    - `.workflow/playbooks/commit.md`
    - `.workflow/playbooks/tdd.md`
    - `.workflow/playbooks/reporting-guidelines.md`
    - `AGENTS.md` (strengthened Codex-specific instructions)

### Improved
- **Enhanced Documentation**: Added explicit continuation instructions throughout all playbooks
- **Better AI Assistant Guidance**: Codex section in AGENTS.md now clearly lists all pause exceptions

---

## [0.3.0-beta] - 2025-11-09

### Added
- **Sequence Numbering for Spec Files**: All spec files now use chronological sequence numbers
  - Format: `.spec/001-feature-name.md`, `.spec/002-fix-name.md`, etc.
  - Provides clear chronological ordering of all work items
  - Shared sequence across features, fixes, and refactors
  - `.spec/.sequence` file tracks next sequence number
  - Updated playbooks: `feature.md`, `bugfix.md`
  - Updated templates: `overall-status-template.md`
  - Updated documentation with examples and guidance

### Improved
- **Smart Re-run Detection in init.sh**: Enhanced update workflow
  - Detects existing installation before asking questions
  - Three update modes:
    1. **Quick Update** (default) - Updates playbooks/templates only, preserves all settings
    2. **Full Reconfigure** - Re-answer all configuration questions
    3. **Cancel** - Exit without changes
  - Preserves `.spec/` files (never overwritten)
  - Clear summary showing what was updated vs. skipped
  - User-friendly prompts with defaults
- **Documentation Updates**:
  - Added "Updating an Existing Installation" section in README
  - Step-by-step update guide with examples
  - Clear explanation of what gets updated vs. preserved

### Changed
- Spec file naming convention now includes sequence numbers
- `overall-status.md` links updated to new naming format
- Examples in README updated to reflect sequenced filenames

### Technical
- Sequence counter stored in `.spec/.sequence`
- Backward compatible: works alongside non-sequenced files (Option 3: Clean Break)
- Auto-increment sequence on each new spec file creation

---

## [0.2.0-beta] - 2025-11-08

### Added
- Example project: TypeScript/Express.js with health endpoint implementation
- Example project: Gemini-specific workflow example
- Enhanced .gitignore for example projects

### Fixed
- **Critical**: Interactive input now works when using `curl | bash` installation
  - Redirect stdin from `/dev/tty` in install.sh
  - All read commands now properly read from terminal
- **Security**: Replaced unsafe `eval` with `printf -v` for variable assignment
  - Prevents command injection vulnerabilities
  - More secure variable handling
- Input validation in `ask_select()` function
  - Added numeric validation before arithmetic operations
  - Proper bounds checking for array indices
  - Graceful fallback to defaults for invalid input
  - Prevents "syntax error: invalid arithmetic operator" errors

### Changed
- Improved README Features section with better visual formatting
- Simplified CHANGELOG planned items to focus on core goals
- Better error handling across all input functions

### Technical Improvements
- More defensive programming for shell compatibility (bash/zsh)
- Regex validation for numeric inputs
- Clear separation of validation logic with comments

---

## [0.1.0-beta] - 2025-11-08

### Added
- **Beta release** of AI Workflow System for early adopters and testing
- Initial release of AI Workflow System
- Interactive setup script (`init.sh`) for project configuration
- Remote installation script (`install.sh`) for direct GitHub installation
- Seven core workflow playbooks:
  - `coordinator.md` - Master router for workflow detection
  - `feature.md` - Feature implementation with TDD
  - `bugfix.md` - Bug fixing workflow with TDD
  - `commit.md` - Pre-commit validation and git commit
  - `tdd.md` - Test-Driven Development cycle (Red-Green-Refactor)
  - `architecture-check.md` - Clean Architecture validation
  - `reporting-guidelines.md` - User visibility requirements
- Language support:
  - TypeScript/JavaScript (Jest, ESLint, Prettier, TSC)
  - Python (pytest, pylint, black, mypy)
  - Java (JUnit, Checkstyle, Google Java Format)
  - Go (go test, golangci-lint, gofmt)
  - Rust (basic support)
  - C# (basic support)
- AI assistant support:
  - Claude Code (native support with parallel execution optimizations)
  - ChatGPT (via AGENTS.md)
  - Google Gemini (via AGENTS.md with platform-specific guidance)
  - GitHub Copilot (via AGENTS.md)
  - Cursor (via AGENTS.md)
  - Codex (via AGENTS.md)
- Configuration system:
  - YAML-based configuration (`config.yml`)
  - Customizable test commands and coverage requirements
  - Configurable architecture layers
  - Naming convention enforcement
- Task tracking system:
  - `.spec/` directory for work tracking
  - Feature, bugfix, and refactor templates
  - Overall status dashboard
- Generated documentation:
  - `AGENTS.md` - Universal AI assistant instructions (language-aware)
  - `CLAUDE.md` - Claude Code-specific optimizations
  - Language-specific code examples
  - Platform-specific troubleshooting
- Clean Architecture enforcement:
  - Dependency rule validation
  - Layer path configuration
  - Pre-commit architecture checks
- Quality standards enforcement:
  - Configurable test coverage requirements
  - TDD enforcement
  - Linting and formatting validation
  - Type checking (for TypeScript, Python)
- Git commit standards:
  - Conventional commits format
  - Commit message validation
  - Pre-commit validation hooks
- Examples:
  - TypeScript/Express.js example configuration
- Community files:
  - MIT License
  - Contributing guidelines
  - Code of Conduct
  - Security policy
  - Changelog
  - Issue templates
  - Pull request template

### Features by Language

#### TypeScript/JavaScript
- Jest test framework integration
- ESLint linting
- Prettier formatting
- TypeScript type checking
- npm build commands

#### Python
- pytest integration
- pylint linting
- black formatting
- mypy type checking
- pip/poetry support

#### Java
- JUnit test framework
- Checkstyle linting
- Google Java Format
- Maven build integration

#### Go
- go test framework
- golangci-lint
- gofmt formatting
- go build commands

### Documentation
- Comprehensive README with examples
- Quick start guide
- Installation instructions (local and remote)
- Language-specific configuration examples
- Architecture philosophy and principles
- FAQ section

---

## Version History

### Version Numbering

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version (X.0.0) - Incompatible API/config changes
- **MINOR** version (0.X.0) - New features, backwards-compatible
- **PATCH** version (0.0.X) - Bug fixes, backwards-compatible

### Upgrade Guide

When upgrading between versions:

1. Check the CHANGELOG for breaking changes
2. Review your `.workflow/config.yml` against new template
3. Re-run `init.sh` to update playbooks (backup your config first!)
4. Test workflows with a sample task
5. Update team documentation if needed

---

## Links

- [GitHub Repository](https://github.com/mandarnilange/ai-workflow-system)
- [Issue Tracker](https://github.com/mandarnilange/ai-workflow-system/issues)
- [Discussions](https://github.com/mandarnilange/ai-workflow-system/discussions)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute to this changelog and the project.

---

## Beta Release Notice

This is a **beta release** (0.1.0-beta). We welcome:
- Bug reports and feedback
- Testing on different languages and frameworks
- Suggestions for improvements
- Contributions to expand language support

Report issues at: https://github.com/mandarnilange/ai-workflow-system/issues

---

[Unreleased]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.6.0-beta...HEAD
[0.6.0-beta]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.5.0-beta...v0.6.0-beta
[0.5.0-beta]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.4.0-beta...v0.5.0-beta
[0.4.0-beta]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.3.0-beta...v0.4.0-beta
[0.3.0-beta]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.2.0-beta...v0.3.0-beta
[0.2.0-beta]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.1.0-beta...v0.2.0-beta
[0.1.0-beta]: https://github.com/mandarnilange/ai-workflow-system/releases/tag/v0.1.0-beta
