# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version     | Supported          |
| ----------- | ------------------ |
| 0.2.0-beta  | :white_check_mark: |
| 0.1.0-beta  | :x:                |
| < 0.1.0     | :x:                |

**Note**: This is a beta release. Security updates will be provided, but the API may change before 1.0.0.

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead:

1. **Email**: Send details to mandarnilange@gmail.com
   - Use subject line: `[SECURITY] Brief description`
   - Include detailed description of the vulnerability
   - Include steps to reproduce
   - Include potential impact assessment

2. **Response Time**:
   - Initial response: Within 48 hours
   - Status update: Within 7 days
   - Fix timeline: Depends on severity (see below)

3. **Disclosure Policy**:
   - We will acknowledge your report within 48 hours
   - We will provide an estimated timeline for a fix
   - We will notify you when the fix is released
   - We will credit you (if desired) in the release notes

### Severity Levels

**Critical** (fix within 7 days)
- Remote code execution
- Arbitrary file access/modification
- Privilege escalation
- Data exposure

**High** (fix within 30 days)
- Information disclosure
- Denial of service
- Authentication bypass

**Medium** (fix within 90 days)
- Cross-site scripting (if applicable)
- Configuration vulnerabilities
- Dependency vulnerabilities

**Low** (fix in next release)
- Minor information leaks
- Best practice violations

## Security Considerations

### Installation Security

**Remote Installation**
```bash
# Our recommended installation method
curl -sSL https://raw.githubusercontent.com/mandarnilange/ai-workflow-system/main/install.sh | bash
```

**Security notes:**
- Always review scripts before piping to bash
- The script only modifies your target directory
- No system-wide changes are made
- No sudo/root access is required

**Safer alternative:**
```bash
# Download and review first
curl -o install.sh https://raw.githubusercontent.com/mandarnilange/ai-workflow-system/main/install.sh
cat install.sh  # Review the script
bash install.sh
```

### Configuration File Security

The `.workflow/config.yml` file may contain:
- Project paths
- Command configurations
- Quality standards

**Best practices:**
- Review the generated config before committing
- Don't commit sensitive data (API keys, passwords, etc.)
- The default `.gitignore` includes guidance on config privacy

### AI Assistant Security

When using AI assistants with this workflow system:

**Data Privacy:**
- AI assistants may send code to external services
- Review your organization's AI usage policies
- Consider using local/private AI instances for sensitive projects

**Code Execution:**
- Playbooks instruct AI to run commands (tests, linting, etc.)
- Always review generated code before execution
- Use in trusted development environments only

**Git Commits:**
- AI assistants may commit code on your behalf
- Review commits before pushing to remote
- Use branch protection rules on important branches

### Bash Script Security

Our `init.sh` and `install.sh` scripts follow these security practices:

- ✅ Input validation on all user inputs
- ✅ Quoted variables to prevent injection
- ✅ No eval on user input
- ✅ Error handling with `set -e`
- ✅ Temporary files cleaned up properly
- ✅ No network requests to untrusted sources
- ✅ No sudo/root required

### Dependency Security

This project has minimal dependencies:

**Runtime:**
- Bash (system)
- Git (for commit playbooks)
- Your project's language tools (npm, python, etc.)

**No npm/pip/gem dependencies** - reduces attack surface

### File System Access

The workflow system:
- ✅ Only writes to your project directory
- ✅ Does not modify system files
- ✅ Does not require elevated permissions
- ✅ Does not access files outside project root
- ✅ Creates `.workflow/`, `.spec/`, and documentation files only

### Known Limitations

**Not a security tool:**
- This is a development workflow system, not a security scanner
- It does not detect security vulnerabilities in your code
- It does not sanitize user input in your application
- It does not protect against supply chain attacks

**Recommendations:**
- Use dedicated security scanners (Snyk, Dependabot, etc.)
- Follow OWASP guidelines for your application
- Implement proper authentication/authorization
- Use security-focused linters (bandit for Python, etc.)

## Security Best Practices for Contributors

When contributing:

1. **Code Review**:
   - All PRs require review
   - Security-sensitive changes require extra scrutiny

2. **Dependencies**:
   - Avoid adding dependencies when possible
   - If needed, use well-maintained, trusted packages
   - Document why the dependency is necessary

3. **Input Validation**:
   - Validate all user inputs in bash scripts
   - Quote all variables
   - Use shellcheck for static analysis

4. **Testing**:
   - Test with malicious inputs
   - Test with special characters
   - Test with very long inputs

## Security Updates

Security updates are released as:
- **Patch versions** (1.0.x) for backward-compatible security fixes
- **GitHub Security Advisories** for critical issues
- **CHANGELOG** entries marked with `[SECURITY]`

Subscribe to releases to stay informed:
- Watch this repository
- Enable GitHub security alerts
- Check CHANGELOG.md regularly

## Acknowledgments

We appreciate responsible disclosure. Security researchers who report valid vulnerabilities will be:
- Credited in release notes (if desired)
- Listed in a future SECURITY_CREDITS.md file
- Thanked publicly (with permission)

## Questions?

For security questions that are not vulnerabilities:
- Open a [GitHub Discussion](https://github.com/mandarnilange/ai-workflow-system/discussions)
- Tag with "security" label
- Do not include sensitive details

For security vulnerabilities:
- Email mandarnilange@gmail.com
- Use PGP if available (optional)

---

**Last Updated:** 2025-11-08
**Next Review:** 2026-02-08
