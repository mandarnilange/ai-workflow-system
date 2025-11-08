import { Router } from 'express';
import { HealthController } from './HealthController';

export class HealthRouter {
  private router: Router;

  constructor(private healthController: HealthController) {
    this.router = Router();
    this.initializeRoutes();
  }

  private initializeRoutes(): void {
    this.router.get('/', this.healthController.getHealthStatus);
  }

  getRouter(): Router {
    return this.router;
  }
}
