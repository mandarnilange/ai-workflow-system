# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for 1.0.0
- Extended testing and validation across multiple AI agents
- Production hardening based on beta feedback
- Additional language support (Ruby, PHP, Rust)

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

[Unreleased]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.2.0-beta...HEAD
[0.2.0-beta]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.1.0-beta...v0.2.0-beta
[0.1.0-beta]: https://github.com/mandarnilange/ai-workflow-system/releases/tag/v0.1.0-beta
