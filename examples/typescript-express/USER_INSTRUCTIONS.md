# User-Specific Instructions

**Add your project-specific instructions here.**

This file is **never overwritten** by init.sh updates. Use it to document:

---

## Team Conventions

Add your team's coding standards and practices here.

Example:
- Use meaningful variable names that reflect business domain
- Prefer composition over inheritance
- Keep functions under 20 lines when possible

---

## Domain-Specific Rules

Document domain knowledge and business rules.

Example:
- User emails must be validated before storage
- Passwords require: 8+ chars, 1 uppercase, 1 number, 1 special char
- Order totals include tax calculation based on shipping address

---

## Project Context

Important context about this specific project.

Example:
- This is a microservice handling user authentication
- We integrate with legacy system XYZ via REST API
- Database migrations run automatically on deployment

---

## Custom Quality Standards

Additional quality requirements beyond .workflow/config.yml

Example:
- All API endpoints must include OpenAPI documentation
- Security-sensitive functions require peer review
- Performance-critical paths need benchmark tests

---

## External Dependencies

Document external systems and APIs.

Example:
- Payment processing: Stripe API v2023-10-16
- Email service: SendGrid (templates in /email-templates)
- Cache: Redis cluster at redis://cache.internal:6379

---

## Development Environment

Setup instructions and environment-specific notes.

Example:
- Requires Node.js 18+ and PostgreSQL 14+
- Run `npm run setup` for initial database seed
- Use `.env.example` as template for `.env`

---

**Note:** Keep this file updated as your project evolves. It helps both AI assistants and human developers understand your project's unique requirements.
