import express, { Express } from 'express';
import { HealthController } from './HealthController';
import { GetHealthStatus } from '../application/GetHealthStatus';
import { UsersController } from './UsersController';
import { GetUsers } from '../application/GetUsers';
import { GetUserById } from '../application/GetUserById';

export function createApp(): Express {
  const app = express();

  // Middleware
  app.use(express.json());

  // Dependency injection (inline for now)
  const getHealthStatus = new GetHealthStatus();
  const healthController = new HealthController(getHealthStatus);

  const getUsers = new GetUsers();
  const getUserById = new GetUserById();
  const usersController = new UsersController(getUsers, getUserById);

  // Routes
  app.get('/healthz', (req, res) => healthController.getHealth(req, res));
  app.get('/api/users', (req, res) => usersController.getUsers(req, res));
  app.get('/api/users/:id', (req, res) => usersController.getUserById(req, res));

  return app;
}
