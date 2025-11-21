import { Request, Response } from 'express';
import { GetHealthStatus } from '../application/GetHealthStatus';

export class HealthController {
  constructor(private readonly getHealthStatus: GetHealthStatus) {}

  getHealth(_req: Request, res: Response): void {
    const healthStatus = this.getHealthStatus.execute();
    res.status(200).json(healthStatus);
  }
}
