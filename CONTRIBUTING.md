# Contributing to AI Workflow System

Thank you for your interest in contributing to AI Workflow System! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Workflow System](#workflow-system)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

---

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

---

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title** - Summarize the issue
- **Description** - Detailed description of the problem
- **Steps to reproduce** - Step-by-step instructions
- **Expected behavior** - What you expected to happen
- **Actual behavior** - What actually happened
- **Environment** - OS, language version, framework version
- **Logs/Screenshots** - Any relevant output or visuals

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md).

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:

- **Clear title** - Summarize the enhancement
- **Use case** - Why is this enhancement needed?
- **Proposed solution** - How should it work?
- **Alternatives** - What alternatives have you considered?
- **Examples** - Any examples from other projects?

Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md).

### Adding Support for New Languages

To add support for a new programming language:

1. Update `init.sh` with language-specific defaults:
   - Test framework
   - Linter and formatter
   - Build commands
   - Naming conventions

2. Add example configuration to `examples/{language}-{framework}/`

3. Test the full workflow with a sample project in that language

4. Update documentation in README.md

### Adding New Playbooks

To create a new workflow playbook:

1. Create `playbooks/{name}.md` with clear step-by-step instructions
2. Follow the existing playbook format:
   - Intent detection criteria
   - Prerequisites
   - Step-by-step execution
   - "Report to user" blocks at each step
   - Validation requirements
3. Update `coordinator.md` to route to your new playbook
4. Test with multiple AI assistants (Claude, ChatGPT, Gemini)
5. Document in README.md

### Improving Documentation

Documentation improvements are always welcome:

- Fix typos or grammatical errors
- Clarify confusing sections
- Add examples
- Improve README structure
- Translate documentation (future)

---

## Development Setup

### Prerequisites

- Bash shell (Linux, macOS, WSL, Git Bash)
- Git
- A test project in your preferred language

### Local Development

1. **Fork and clone the repository**

   ```bash
   git clone https://github.com/YOUR_USERNAME/ai-workflow-system.git
   cd ai-workflow-system
   ```

2. **Create a test project**

   ```bash
   mkdir test-project
   cd test-project
   npm init -y  # or python -m venv venv, etc.
   ```

3. **Run the install script**

   ```bash
   ../init.sh .
   ```

4. **Test the workflows**

   Follow the generated playbooks in `.workflow/playbooks/` and verify they work correctly.

5. **Make your changes**

   Edit the relevant files in the `ai-workflow-system` directory.

6. **Test your changes**

   Run `init.sh` again on a fresh test project to verify your changes work.

---

## Workflow System

**IMPORTANT**: This project uses its own workflow system!

When contributing code:

1. **Read** `.workflow/playbooks/coordinator.md`
2. **Follow TDD** - Write tests first
3. **Validate** - Run all validators before committing
4. **Track** - Update `.spec/` files

We eat our own dog food! The workflow system enforces:
- Test-Driven Development
- Clean Architecture (for code contributions)
- Quality standards

---

## Submitting Changes

### Pull Request Process

1. **Create a branch**

   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

2. **Make your changes**

   - Follow the [Style Guidelines](#style-guidelines)
   - Write or update tests if applicable
   - Update documentation

3. **Test thoroughly**

   - Test on at least 2 different languages
   - Test with at least 2 different AI assistants
   - Verify install script works
   - Check generated files are correct

4. **Commit your changes**

   Follow conventional commits:

   ```bash
   git commit -m "feat: add support for Ruby language"
   git commit -m "fix: correct TypeScript test pattern"
   git commit -m "docs: improve CONTRIBUTING.md clarity"
   ```

5. **Push to your fork**

   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**

   - Use the PR template
   - Link related issues
   - Describe your changes clearly
   - Explain testing performed

### Pull Request Requirements

Before your PR can be merged:

- [ ] Code follows style guidelines
- [ ] Tests pass (if applicable)
- [ ] Documentation is updated
- [ ] Commit messages follow conventional commits
- [ ] PR description is clear and complete
- [ ] No merge conflicts

---

## Style Guidelines

### Bash Scripts

- Use 4-space indentation
- Quote variables: `"$VARIABLE"` not `$VARIABLE`
- Use meaningful variable names (UPPER_CASE for constants)
- Add comments for complex logic
- Use functions for reusable code
- Validate inputs

Example:
```bash
# Good
ask() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    echo -ne "${YELLOW}${prompt} [${default}]: ${NC}"
    read -r input

    if [ -z "$input" ]; then
        eval "$var_name=\"$default\""
    else
        eval "$var_name=\"$input\""
    fi
}

# Bad
ask() {
echo $1
read x
}
```

### Markdown (Playbooks & Docs)

- Use clear headers (`##`, `###`)
- Include code examples with language tags
- Use **bold** for emphasis, `code` for commands/files
- Add "Report to user:" blocks in playbooks
- Keep lines under 100 characters when possible

### YAML Configuration

- Use 2-space indentation
- Add comments for all fields
- Group related settings
- Use quotes for string values

---

## Community

### Getting Help

- **Questions**: Use [GitHub Discussions](https://github.com/mandarnilange/ai-workflow-system/discussions)
- **Bugs**: Use [GitHub Issues](https://github.com/mandarnilange/ai-workflow-system/issues)
- **Security**: See [SECURITY.md](SECURITY.md)

### Recognition

Contributors will be recognized in:
- GitHub contributors page
- Future CONTRIBUTORS.md file
- Release notes (for significant contributions)

---

## Development Roadmap

Interested in working on something? Check out:

- [Open Issues](https://github.com/mandarnilange/ai-workflow-system/issues)
- [Project Board](https://github.com/mandarnilange/ai-workflow-system/projects) (if available)
- Future enhancements in README.md

---

## Questions?

If you have questions about contributing, please:

1. Check this document
2. Search existing [Issues](https://github.com/mandarnilange/ai-workflow-system/issues) and [Discussions](https://github.com/mandarnilange/ai-workflow-system/discussions)
3. Open a new Discussion if your question isn't answered

---

**Thank you for contributing to AI Workflow System!** 🚀

Your contributions help improve AI-assisted development for everyone.
