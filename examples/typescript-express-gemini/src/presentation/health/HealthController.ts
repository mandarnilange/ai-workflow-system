import { Request, Response } from 'express';
import { GetHealthStatusUseCase } from '../../../src/application/health/GetHealthStatusUseCase';

export class HealthController {
  constructor(private getHealthStatusUseCase: GetHealthStatusUseCase) {}

  getHealthStatus = (req: Request, res: Response): void => {
    const healthResponse = this.getHealthStatusUseCase.execute();
    res.status(healthResponse.status).json(healthResponse);
  };
}
