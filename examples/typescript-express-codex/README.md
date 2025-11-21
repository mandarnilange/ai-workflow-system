# TypeScript Express Codex Example

Simple Express API demonstrating the AI workflow system with Clean Architecture boundaries.

## Available Endpoints

- `GET /health` – returns service health payload.
- `GET /api/users` – returns mock list of users defined in fixtures.
- `GET /api/users/:id` – returns a single mock user by id or a 404 JSON error if the id is unknown.

## Development

```bash
npm install
npm test          # runs Jest suite with 100% coverage target
npm run lint      # ESLint across src + tests
```
