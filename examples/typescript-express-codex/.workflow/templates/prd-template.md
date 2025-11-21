# PRD Template

**Purpose**: Use this template to structure your PRD for the PRD Planning workflow.

**Note**: This template is OPTIONAL. You can provide PRD information in any format (bullet list, paragraph, etc.). This template just helps ensure all useful information is captured.

---

## Project Overview

**Project Name**: {Your Project Name}

**Description**: {Brief description of the overall project/product}

**Goals**:
- {Goal 1}
- {Goal 2}
- {Goal 3}

**Success Metrics**:
- {Metric 1: e.g., "100% test coverage"}
- {Metric 2: e.g., "< 200ms API response time"}
- {Metric 3: e.g., "Support 10K concurrent users"}

---

## Features

List all features you want to plan. For each feature, provide as much detail as you can. Missing information is OK - the system will use defaults.

### Feature 1: {Feature Name}

**Description**: {What does this feature do? Why is it needed?}

**Priority**: {High | Medium | Low}

**Dependencies**: {List other features this depends on, or "None"}

**Acceptance Criteria**:
- {Criterion 1: e.g., "User can login with email/password"}
- {Criterion 2: e.g., "Password must be hashed with bcrypt"}
- {Criterion 3: e.g., "Session expires after 24 hours"}

**Estimated Complexity**: {Low | Medium | High | Unknown}

**Notes**: {Any additional context, constraints, or considerations}

---

### Feature 2: {Feature Name}

**Description**: {What does this feature do? Why is it needed?}

**Priority**: {High | Medium | Low}

**Dependencies**: {List other features this depends on, or "None"}

**Acceptance Criteria**:
- {Criterion 1}
- {Criterion 2}
- {Criterion 3}

**Estimated Complexity**: {Low | Medium | High | Unknown}

**Notes**: {Any additional context, constraints, or considerations}

---

### Feature 3: {Feature Name}

**Description**: {What does this feature do? Why is it needed?}

**Priority**: {High | Medium | Low}

**Dependencies**: {List other features this depends on, or "None"}

**Acceptance Criteria**:
- {Criterion 1}
- {Criterion 2}
- {Criterion 3}

**Estimated Complexity**: {Low | Medium | High | Unknown}

**Notes**: {Any additional context, constraints, or considerations}

---

## Technical Constraints

**Technology Stack**:
- Language: {e.g., TypeScript, Python, Java}
- Framework: {e.g., Express, FastAPI, Spring Boot}
- Database: {e.g., PostgreSQL, MongoDB, MySQL}
- Other: {e.g., Redis for caching, S3 for storage}

**Architecture**:
- Style: {e.g., Clean Architecture, Hexagonal, Layered}
- Patterns: {e.g., Repository, CQRS, Event-Driven}

**Quality Requirements**:
- Test Coverage: {e.g., 100%, 90%, 80%}
- Architecture Compliance: {Required | Preferred | Optional}
- Code Quality: {Linting required, formatting standards}

---

## Non-Functional Requirements

**Performance**:
- {e.g., "API response < 200ms for 95th percentile"}
- {e.g., "Support 10K concurrent users"}

**Security**:
- {e.g., "All passwords hashed with bcrypt"}
- {e.g., "JWT tokens for authentication"}
- {e.g., "HTTPS only"}

**Scalability**:
- {e.g., "Horizontal scaling with load balancer"}
- {e.g., "Database read replicas for queries"}

**Observability**:
- {e.g., "Structured logging with Winston"}
- {e.g., "Metrics with Prometheus"}
- {e.g., "Distributed tracing with Jaeger"}

---

## Timeline

**Target Milestones**:
- Phase 1: {Feature X, Feature Y} - {Date or "2 weeks"}
- Phase 2: {Feature Z, Feature W} - {Date or "4 weeks"}
- Phase 3: {Feature A, Feature B} - {Date or "6 weeks"}

**MVP Definition**:
- Minimum features for MVP: {List features}
- Target MVP date: {Date or "4 weeks from start"}

---

## Risks and Assumptions

**Risks**:
- {Risk 1: e.g., "Third-party API may have rate limits"}
- {Risk 2: e.g., "Database migration may cause downtime"}

**Assumptions**:
- {Assumption 1: e.g., "Users have modern browsers (Chrome 90+)"}
- {Assumption 2: e.g., "Infrastructure can handle 10K users"}

**Mitigation**:
- {Mitigation for Risk 1}
- {Mitigation for Risk 2}

---

## Usage with AI Workflow System

### To use this PRD with the planning workflow:

**Option 1: Copy-paste this entire filled template**
```
User: "Plan this PRD: [paste entire PRD]"
```

**Option 2: Provide a simple list**
```
User: "Plan a PRD with 3 features: user authentication, product catalog, shopping cart.
Product catalog depends on user auth. Shopping cart depends on both."
```

**Option 3: Reference a file**
```
User: "Plan the PRD in docs/prd.md"
```

### What the system will do:

1. **Analyze** your PRD input (any format works)
2. **Extract** feature names, descriptions, priorities, dependencies
3. **Confirm** the feature list with you
4. **Create** `.spec/00X-feature-*.md` files for each feature (Status: Pending)
5. **Update** `.spec/overall-status.md` dashboard
6. **Recommend** implementation order based on dependencies and priorities

### After planning:

You can then implement features one at a time:
```
User: "Implement feature 001"
```

Or by name:
```
User: "Implement user authentication"
```

Each implementation will:
- Follow TDD (tests-first)
- Respect Clean Architecture layers
- Validate with 3 parallel checks (tests, architecture, linting)
- Update `.spec/` progress tracking
- Create conventional commits

---

## Example: E-commerce MVP PRD

### Project Overview

**Project Name**: E-commerce Platform MVP

**Description**: A simple e-commerce platform with user accounts, product browsing, and shopping cart functionality.

**Goals**:
- Enable users to browse and purchase products
- Provide secure authentication and payment processing
- Maintain 100% test coverage

**Success Metrics**:
- 100% test coverage
- < 200ms API response time (95th percentile)
- Clean Architecture compliance

---

### Features

#### Feature 1: User Authentication

**Description**: Allow users to register, login, and manage their accounts using email/password authentication.

**Priority**: High

**Dependencies**: None

**Acceptance Criteria**:
- Users can register with email and password
- Passwords are hashed with bcrypt (min 10 rounds)
- Users can login with email/password
- JWT tokens issued on successful login (24-hour expiry)
- Users can logout (token invalidation)
- Password reset via email (optional for MVP)

**Estimated Complexity**: Medium

**Notes**: Use bcrypt for password hashing. Consider email verification for post-MVP.

---

#### Feature 2: Product Catalog

**Description**: Display a catalog of products with details, images, and pricing. Users can search and filter products.

**Priority**: High

**Dependencies**: User Authentication (users must be logged in to view catalog)

**Acceptance Criteria**:
- Display list of products with name, price, image
- Product detail page with full description
- Search products by name/description
- Filter products by category and price range
- Pagination (20 products per page)

**Estimated Complexity**: High

**Notes**: Requires product database seeding. Consider image CDN for production.

---

#### Feature 3: Shopping Cart

**Description**: Allow users to add products to a cart, modify quantities, and view total price.

**Priority**: Medium

**Dependencies**: User Authentication, Product Catalog

**Acceptance Criteria**:
- Add product to cart
- Update product quantity in cart
- Remove product from cart
- View cart with all items and total price
- Cart persists across sessions (stored in database)
- Calculate total price including any taxes/fees

**Estimated Complexity**: Medium

**Notes**: Cart should be user-specific. Consider cart abandonment tracking for post-MVP.

---

#### Feature 4: Checkout and Payment

**Description**: Process orders and handle payment via Stripe integration.

**Priority**: Medium

**Dependencies**: User Authentication, Product Catalog, Shopping Cart

**Acceptance Criteria**:
- Display order summary before payment
- Integrate Stripe for payment processing
- Create order record on successful payment
- Send order confirmation email
- Clear cart after successful order
- Handle payment failures gracefully

**Estimated Complexity**: High

**Notes**: Use Stripe test mode for development. Requires Stripe API keys.

---

#### Feature 5: Order History

**Description**: Allow users to view their past orders and order details.

**Priority**: Low

**Dependencies**: User Authentication, Checkout and Payment

**Acceptance Criteria**:
- Display list of user's past orders
- Show order date, total price, status
- View detailed order information (items, quantities, prices)
- Filter orders by date range
- Export order history as CSV (optional for MVP)

**Estimated Complexity**: Low

**Notes**: Simple read-only feature. Can be implemented quickly after checkout.

---

### Technical Constraints

**Technology Stack**:
- Language: TypeScript
- Framework: Express.js
- Database: PostgreSQL
- ORM: TypeORM or Prisma
- Authentication: JWT with bcrypt
- Payment: Stripe
- Testing: Jest
- Linting: ESLint with TypeScript

**Architecture**:
- Style: Clean Architecture (5 layers: Domain, Application, Infrastructure, Presentation, DI)
- Patterns: Repository pattern, Dependency Injection

**Quality Requirements**:
- Test Coverage: 100% (enforced)
- Architecture Compliance: Required (validated before commits)
- Code Quality: ESLint rules enforced

---

### Non-Functional Requirements

**Performance**:
- API response < 200ms for 95th percentile
- Support 1K concurrent users initially
- Database query optimization (indexes on foreign keys)

**Security**:
- All passwords hashed with bcrypt (min 10 rounds)
- JWT tokens for authentication (24-hour expiry)
- HTTPS only in production
- Input validation and sanitization
- SQL injection prevention (via ORM)
- XSS prevention (via output encoding)

**Scalability**:
- Horizontal scaling with load balancer (post-MVP)
- Database connection pooling
- Redis for session storage (optional for MVP)

**Observability**:
- Structured logging with Winston
- Request/response logging
- Error tracking with Sentry (optional)

---

### Timeline

**Target Milestones**:
- Phase 1: User Authentication - Week 1-2
- Phase 2: Product Catalog - Week 3-4
- Phase 3: Shopping Cart - Week 5
- Phase 4: Checkout and Payment - Week 6-7
- Phase 5: Order History - Week 8

**MVP Definition**:
- Minimum features: User Authentication, Product Catalog, Shopping Cart, Checkout
- Target MVP: 7 weeks from start
- Order History is post-MVP (nice-to-have)

---

### Risks and Assumptions

**Risks**:
- Stripe integration may be complex (unfamiliar API)
- Image storage could become expensive (many products)
- Payment processing failures need robust error handling

**Assumptions**:
- Users have modern browsers (Chrome 90+, Firefox 85+, Safari 14+)
- Infrastructure can handle 1K concurrent users
- Stripe API is stable and reliable
- Product catalog < 10K products (no need for Elasticsearch)

**Mitigation**:
- Stripe: Use Stripe Elements for PCI compliance, test mode extensively
- Images: Use cloudinary or S3 with CDN
- Payments: Implement retry logic, user-friendly error messages
- Load testing before production launch

---

## How to Use This PRD

With this PRD filled out, you would use it like this:

```
User: "Plan this PRD:

E-commerce Platform MVP with 5 features:

1. User Authentication (High priority, no dependencies)
   - Email/password registration and login
   - JWT tokens with 24-hour expiry
   - bcrypt password hashing

2. Product Catalog (High priority, depends on User Authentication)
   - List and detail views
   - Search and filtering
   - Pagination

3. Shopping Cart (Medium priority, depends on User Authentication and Product Catalog)
   - Add/update/remove items
   - Persistent cart (database)
   - Price calculation

4. Checkout and Payment (Medium priority, depends on all above)
   - Stripe integration
   - Order creation
   - Email confirmation

5. Order History (Low priority, depends on Checkout)
   - View past orders
   - Order details
   - Date filtering
"
```

The system will:
1. Confirm the 5 features with you
2. Create `.spec/001-feature-user-authentication.md` through `.spec/005-feature-order-history.md`
3. Update `.spec/overall-status.md`
4. Recommend starting with Feature 1 (User Authentication) since it has no dependencies

Then you can implement:
```
User: "Implement feature 001"
```

And the TDD workflow begins!
