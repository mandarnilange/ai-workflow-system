---
name: Language/Framework Support Request
about: Request support for a new programming language or framework
title: '[LANGUAGE] Add support for '
labels: enhancement, language-support
assignees: ''
---

## Language/Framework Details

**Language:** [e.g., Ruby, PHP, Rust, C++]

**Framework (if applicable):** [e.g., Ruby on Rails, Laravel, Actix, Qt]

**Popularity/Usage:**
- GitHub repositories using this: [estimate or link to stats]
- Use case: [web dev, data science, systems programming, etc.]

## Current Status

**Does it work currently?**
- [ ] Yes, but needs better defaults
- [ ] Partially (explain: _______)
- [ ] No, not supported

**If partially working, what issues exist?**

## Proposed Defaults

### Testing
- **Test framework:** [e.g., RSpec, PHPUnit, cargo test]
- **Test command:** [e.g., `bundle exec rspec`, `vendor/bin/phpunit`]
- **Coverage command:** [e.g., `bundle exec rspec --coverage`]
- **Test directory:** [e.g., `spec/`, `tests/`, `test/`]
- **Test file pattern:** [e.g., `*_spec.rb`, `*Test.php`, `*_test.rs`]

### Code Quality
- **Linter:** [e.g., RuboCop, PHP_CodeSniffer, Clippy]
- **Lint command:** [e.g., `bundle exec rubocop`, `phpcs`, `cargo clippy`]
- **Formatter:** [e.g., StandardRB, PHP-CS-Fixer, rustfmt]
- **Format command:** [e.g., `bundle exec standardrb --check`, `php-cs-fixer fix --dry-run`]

### Build (if applicable)
- **Build required:** [true/false]
- **Build command:** [e.g., `bundle install`, `composer install`, `cargo build`]
- **Build output:** [e.g., `vendor/`, `target/`, `build/`]

### Naming Conventions
- **Classes:** [e.g., PascalCase, snake_case]
- **Functions:** [e.g., snake_case, camelCase]
- **Files:** [e.g., snake_case.rb, PascalCase.php]
- **Constants:** [e.g., UPPER_SNAKE_CASE, SCREAMING_SNAKE_CASE]

### Architecture
Are there common patterns for Clean Architecture in this language?
- **Domain layer:** [typical location/naming]
- **Application layer:** [typical location/naming]
- **Infrastructure layer:** [typical location/naming]

## Example Project

**Link to example project (if available):**

**Sample directory structure:**
```
project-root/
├── lib/
│   ├── domain/
│   ├── application/
│   └── infrastructure/
├── spec/
└── ...
```

## Testing Strategy

**How can we test this?**
- [ ] I can provide a sample project
- [ ] I can test changes on my projects
- [ ] I can create example configuration
- [ ] Other: _______

## Additional Context

Add any other context, links to documentation, or examples.

**Resources:**
- Official documentation: [link]
- Testing framework docs: [link]
- Common project templates: [link]

## Contribution

- [ ] I'm willing to help implement this
- [ ] I can provide example configurations
- [ ] I can test changes
- [ ] I can write documentation

## Checklist

- [ ] I have checked this language isn't already supported
- [ ] I have provided all necessary defaults
- [ ] I have included testing information
- [ ] I have considered Clean Architecture patterns
