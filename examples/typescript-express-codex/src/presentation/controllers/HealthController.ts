import { Request, Response } from 'express';
import { HealthCheckPort } from '../../application/health/CheckHealthUseCase';

export class HealthController {
  constructor(private readonly checkHealthUseCase: HealthCheckPort) {}

  async handle(_req: Request, res: Response): Promise<Response> {
    const healthStatus = await this.checkHealthUseCase.execute();
    const payload = healthStatus.toJSON();

    return res.status(payload.httpStatus).json(payload);
  }
}
