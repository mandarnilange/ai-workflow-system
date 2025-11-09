import express, { Express } from 'express';
import { HealthController } from './HealthController';
import { GetHealthStatus } from '../application/GetHealthStatus';

export function createApp(): Express {
  const app = express();

  // Middleware
  app.use(express.json());

  // Dependency injection (inline for now)
  const getHealthStatus = new GetHealthStatus();
  const healthController = new HealthController(getHealthStatus);

  // Routes
  app.get('/healthz', (req, res) => healthController.getHealth(req, res));

  return app;
}
