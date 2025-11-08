# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for 1.0.0
- Extended testing and validation across multiple AI agents
- Production hardening based on beta feedback
- Bug fixes and stability improvements

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

[Unreleased]: https://github.com/mandarnilange/ai-workflow-system/compare/v0.1.0-beta...HEAD
[0.1.0-beta]: https://github.com/mandarnilange/ai-workflow-system/releases/tag/v0.1.0-beta
