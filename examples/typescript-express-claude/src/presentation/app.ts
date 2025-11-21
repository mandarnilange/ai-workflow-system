import express, { Express } from 'express';
import { HealthController } from './HealthController';
import { GetHealthStatus } from '../application/GetHealthStatus';
import { UsersController } from './UsersController';
import { GetUsers } from '../application/GetUsers';

export function createApp(): Express {
  const app = express();

  // Middleware
  app.use(express.json());

  // Dependency injection (inline for now)
  const getHealthStatus = new GetHealthStatus();
  const healthController = new HealthController(getHealthStatus);

  const getUsers = new GetUsers();
  const usersController = new UsersController(getUsers);

  // Routes
  app.get('/healthz', (req, res) => healthController.getHealth(req, res));
  app.get('/api/users', (req, res) => usersController.getUsers(req, res));

  return app;
}
