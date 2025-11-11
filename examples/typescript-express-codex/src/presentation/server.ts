import express, { Express, NextFunction } from 'express';
import { AppContainer, createContainer } from '../di/container';

export const buildApp = (container?: AppContainer): Express => {
  const resolvedContainer = container ?? createContainer();
  const app = express();

  app.get('/health', async (req, res, next: NextFunction) => {
    try {
      await resolvedContainer.healthController.handle(req, res);
    } catch (error) {
      next(error);
    }
  });

  app.get('/api/users', async (req, res, next: NextFunction) => {
    try {
      await resolvedContainer.usersController.handle(req, res);
    } catch (error) {
      next(error);
    }
  });

  return app;
};

/* istanbul ignore next */
if (require.main === module) {
  const app = buildApp();
  const port = process.env.PORT ?? 3000;
  app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
  });
}
