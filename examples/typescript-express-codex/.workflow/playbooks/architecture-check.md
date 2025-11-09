# Architecture Validation Playbook

**Purpose**: Validate Clean Architecture compliance (dependency rules).

**When to use**: Before commits, after implementing new layers/modules.

---

## IMPORTANT: Read Reporting Guidelines FIRST

**BEFORE executing this playbook**, read: `.workflow/playbooks/reporting-guidelines.md`

You MUST announce validation progress layer-by-layer to keep the user informed.

---

## Step 0: Announce Validation Start

**Report to user**:
```
🏛️ Architecture Validation

Executing: .workflow/playbooks/architecture-check.md

Validating Clean Architecture compliance:
- Domain layer (no dependencies)
- Application layer (domain only)
- Infrastructure layer (app + domain)
- Presentation layer (app + domain, NOT infra)

Let's begin...
```

---

## Clean Architecture Principles

### The Dependency Rule

**Dependencies must point INWARD only** (toward the domain).

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

Each layer can only depend on the layers immediately inside it.

### Allowed Dependencies

From `.workflow/config.yml`:

| Layer | Can Depend On |
|-------|---------------|
| Domain | Nothing (pure TypeScript) |
| Application | Domain only |
| Infrastructure | Application + Domain |
| Presentation | Application + Domain (NOT Infrastructure) |
| DI | All layers (wires everything) |

---

## Step 1: Read Project Structure

**Report to user**:
```
## Step 1: Reading Project Structure

Identifying layer directories and source files...
```

### 1.1 Identify Layer Directories

```bash
ls -la src/
```

Expected structure:
```
src/
├── domain/          # Pure business logic
├── application/     # Use cases
├── infrastructure/  # Implementations
├── presentation/    # Controllers, routes
└── di/              # Dependency injection
```

### 1.2 List All Source Files

```bash
find src/ -name "*.ts" -type f
```

Note all files in each layer.

**Report to user after reading structure**:
```
✅ Step 1 Complete: Project Structure Identified

Layers found:
- Domain: {count} files
- Application: {count} files
- Infrastructure: {count} files
- Presentation: {count} files
- DI: {count} files

Next: Step 2 - Check Domain Layer
```

---

## Step 2: Check Domain Layer (No Dependencies)

**Report to user**:
```
## Step 2: Checking Domain Layer

Validating: Domain has no dependencies on other layers...
```

### 2.1 Find All Domain Files

```bash
find src/domain/ -name "*.ts" -type f
```

### 2.2 Check Imports in Domain Files

For each domain file, check imports:

```bash
grep -n "^import" src/domain/**/*.ts
```

**Validation Rules**:

✅ **Allowed in Domain**:
- No imports from other project layers
- Only TypeScript built-ins
- Only type imports (if truly needed)

❌ **NOT Allowed in Domain**:
- Imports from `application/`
- Imports from `infrastructure/`
- Imports from `presentation/`
- Imports from `di/`
- External libraries (except pure type definitions)

**Example**:
```typescript
// ✅ ALLOWED in Domain
export interface User {
  id: string
  name: string
  email: string
}

export interface UserRepository {
  findAll(): Promise<User[]>
}

// ❌ NOT ALLOWED in Domain
import { SomeUseCase } from '../application/SomeUseCase' // Violates rule
import express from 'express' // External dependency
```

### 2.3 Report Domain Violations

**If violations found**:
```
❌ Domain Layer: {count} Violations

File: src/domain/User.ts
Line 3: import { SomeUseCase } from '../application/SomeUseCase'
Reason: Domain cannot depend on Application layer

Action required:
- Remove the import
- Move shared code to Domain
- Use dependency injection instead
```

**If no violations**:
```
✅ Domain Layer: Clean

All {count} domain files validated.
No dependencies on other layers. ✅

Next: Step 3 - Check Application Layer
```

---

## Step 3: Check Application Layer (Domain Only)

**Report to user**:
```
## Step 3: Checking Application Layer

Validating: Application depends only on Domain...
```

### 3.1 Find All Application Files

```bash
find src/application/ -name "*.ts" -type f
```

### 3.2 Check Imports in Application Files

```bash
grep -n "^import.*from.*'\.\." src/application/**/*.ts
```

**Validation Rules**:

✅ **Allowed in Application**:
- Imports from `domain/`
- TypeScript built-ins
- Pure libraries (no framework-specific code)

❌ **NOT Allowed in Application**:
- Imports from `infrastructure/`
- Imports from `presentation/`
- Imports from `di/`
- Framework imports (Express, etc.)

**Example**:
```typescript
// ✅ ALLOWED in Application
import { User, UserRepository } from '../domain/User'

export class GetUsers {
  constructor(private repository: UserRepository) {}

  async execute() {
    return await this.repository.findAll()
  }
}

// ❌ NOT ALLOWED in Application
import { InMemoryUserRepository } from '../infrastructure/InMemoryUserRepository'
import { Request, Response } from 'express'
```

### 3.3 Report Application Violations

**If violations found**:
```
❌ Application Layer: {count} Violations

File: src/application/GetUsers.ts
Line 5: import { InMemoryUserRepository } from '../infrastructure/...'
Reason: Application cannot depend on Infrastructure layer

Action required:
- Use interface (UserRepository) instead
- Inject concrete implementation via DI
```

**If no violations**:
```
✅ Application Layer: Clean

All {count} application files validated.
Only depends on Domain. ✅

Next: Step 4 - Check Infrastructure Layer
```

---

## Step 4: Check Infrastructure Layer (Application + Domain)

**Report to user**:
```
## Step 4: Checking Infrastructure Layer

Validating: Infrastructure depends only on Application + Domain...
```

### 4.1 Find All Infrastructure Files

```bash
find src/infrastructure/ -name "*.ts" -type f
```

### 4.2 Check Imports

```bash
grep -n "^import.*from.*'\.\." src/infrastructure/**/*.ts
```

**Validation Rules**:

✅ **Allowed in Infrastructure**:
- Imports from `domain/`
- Imports from `application/`
- External libraries
- Framework code (Express, databases, etc.)

❌ **NOT Allowed in Infrastructure**:
- Imports from `presentation/`
- Imports from `di/`

**Example**:
```typescript
// ✅ ALLOWED in Infrastructure
import { User, UserRepository } from '../domain/User'

export class InMemoryUserRepository implements UserRepository {
  private users: User[] = []

  async findAll(): Promise<User[]> {
    return this.users
  }
}

// ❌ NOT ALLOWED in Infrastructure
import { UserController } from '../presentation/UserController'
```

**If no violations**:
```
✅ Infrastructure Layer: Clean

All {count} infrastructure files validated.
Only depends on Application + Domain. ✅

Next: Step 5 - Check Presentation Layer
```

---

## Step 5: Check Presentation Layer (Application + Domain)

**Report to user**:
```
## Step 5: Checking Presentation Layer

Validating: Presentation depends only on Application + Domain (NOT Infrastructure)...
```

### 5.1 Find All Presentation Files

```bash
find src/presentation/ -name "*.ts" -type f
```

### 5.2 Check Imports

```bash
grep -n "^import.*from.*'\.\." src/presentation/**/*.ts
```

**Validation Rules**:

✅ **Allowed in Presentation**:
- Imports from `domain/`
- Imports from `application/`
- Framework imports (Express Request/Response)

❌ **NOT Allowed in Presentation**:
- Imports from `infrastructure/` (CRITICAL)
- Imports from `di/`

**Example**:
```typescript
// ✅ ALLOWED in Presentation
import { GetUsers } from '../application/GetUsers'
import { Request, Response } from 'express'

export class UserController {
  constructor(private getUsers: GetUsers) {}

  async getAll(req: Request, res: Response) {
    const result = await this.getUsers.execute()
    res.json(result)
  }
}

// ❌ NOT ALLOWED in Presentation
import { InMemoryUserRepository } from '../infrastructure/InMemoryUserRepository'
```

**This is the most common violation** - Presentation should NEVER import from Infrastructure directly.

**If violations found**:
```
❌ Presentation Layer: {count} Violations

File: src/presentation/UserController.ts
Line 2: import { InMemoryUserRepository } from '../infrastructure/...'
Reason: Presentation cannot depend on Infrastructure layer (most common violation!)

Action required:
- Remove Infrastructure imports
- Use Use Cases (Application layer) instead
- Inject dependencies via DI layer
```

**If no violations**:
```
✅ Presentation Layer: Clean

All {count} presentation files validated.
Only depends on Application + Domain. ✅
No Infrastructure dependencies found. ✅

Next: Step 6 - Generate Validation Report
```

---

## Step 6: Generate Validation Report

**Report to user**:
```
## Step 6: Generating Validation Report

Summarizing findings across all layers...
```

### 6.1 Summarize Findings

Collect all violations from Steps 2-5.

### 6.2 Count Violations by Type

```
Architecture Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Violations by Layer:
- Domain: {count}
- Application: {count}
- Infrastructure: {count}
- Presentation: {count}

Total Violations: {total}
```

### 6.3 Provide Detailed Report

For each violation:
```
Violation #{number}
━━━━━━━━━━━━━━━━
Layer: {layer name}
File: {file path}:{line number}
Code: {import statement}
Rule: {which rule violated}
Fix: {how to fix}
```

---

## Step 7: Pass/Fail Decision

### If Zero Violations:

**Report to user**:
```
✅ Architecture Validation PASSED

Clean Architecture Compliance: 100%

Layer Results:
✅ Domain ({file_count} files): No dependencies
✅ Application ({file_count} files): Domain only
✅ Infrastructure ({file_count} files): Application + Domain
✅ Presentation ({file_count} files): Application + Domain

Total Violations: 0

All layers respect dependency rules. ✅
```

**Exit code: 0**

### If Any Violations:

**Report to user**:
```
❌ Architecture Validation FAILED

Total Violations: {count}

Layer Results:
{Show each layer with violation count}

Cannot proceed - fix violations before committing.

See detailed violation reports above for specific issues and fixes.
```

**Exit code: 1**

---

## Common Violations and Fixes

### Violation 1: Presentation imports Infrastructure

```typescript
// ❌ WRONG
// src/presentation/UserController.ts
import { InMemoryUserRepository } from '../infrastructure/InMemoryUserRepository'

export class UserController {
  constructor() {
    this.repository = new InMemoryUserRepository()
  }
}
```

**Fix**: Use dependency injection

```typescript
// ✅ CORRECT
// src/presentation/UserController.ts
import { GetUsers } from '../application/GetUsers'

export class UserController {
  constructor(private getUsers: GetUsers) {}
}

// Wiring happens in DI layer:
// src/di/container.ts
const repository = new InMemoryUserRepository()
const getUsers = new GetUsers(repository)
const controller = new UserController(getUsers)
```

### Violation 2: Application imports Infrastructure

```typescript
// ❌ WRONG
// src/application/GetUsers.ts
import { InMemoryUserRepository } from '../infrastructure/InMemoryUserRepository'

export class GetUsers {
  private repository = new InMemoryUserRepository()
}
```

**Fix**: Use interface + dependency injection

```typescript
// ✅ CORRECT
// src/application/GetUsers.ts
import { UserRepository } from '../domain/User'

export class GetUsers {
  constructor(private repository: UserRepository) {}
}
```

### Violation 3: Domain imports anything

```typescript
// ❌ WRONG
// src/domain/User.ts
import { GetUsers } from '../application/GetUsers'

export interface User {
  useCase: GetUsers // Wrong!
}
```

**Fix**: Keep domain pure

```typescript
// ✅ CORRECT
// src/domain/User.ts
export interface User {
  id: string
  name: string
  email: string
}

// No imports from other layers
```

---

## Tools for Validation

### Manual Validation (what this playbook does)
- Grep for imports
- Check each layer manually
- Report violations

### Automated Tools (optional)
- `dependency-cruiser` - NPM package for dependency validation
- `madge` - Circular dependency detection
- Custom ESLint rules

---

## Integration with Commit Workflow

This playbook is called by `.workflow/playbooks/commit.md`:

```
Commit Workflow
  → Step 2.3: Run Architecture Validator
    → Execute: architecture-check.md
    → If fails: Block commit
    → If passes: Continue
```

---

## Checklist for AI Assistants

- [ ] Checked Domain layer (no dependencies)
- [ ] Checked Application layer (domain only)
- [ ] Checked Infrastructure layer (app + domain only)
- [ ] Checked Presentation layer (app + domain only, NOT infra)
- [ ] Generated comprehensive report
- [ ] Provided fixes for each violation
- [ ] Returned correct exit code (0 = pass, 1 = fail)

---

## Notes

- **Presentation → Infrastructure violation is most common**
- Always use interfaces + dependency injection
- DI layer is allowed to wire everything
- Focus on import statements (they reveal dependencies)
- Circular dependencies are also violations
