import request from 'supertest';
import express from 'express';
import { HealthController } from '../../../src/presentation/health/HealthController';
import { GetHealthStatusUseCase } from '../../../src/application/health/GetHealthStatusUseCase';
import { HealthResponse } from '../../../src/domain/health/HealthResponse';
import { HealthRouter } from '../../../src/presentation/health/HealthRouter';

describe('Health Routes', () => {
  let app: express.Application;
  let getHealthStatusUseCase: GetHealthStatusUseCase;
  let healthController: HealthController;
  let healthRouter: HealthRouter;

  beforeAll(() => {
    const mockTimestamp = '2025-11-08T12:00:00.000Z';
    getHealthStatusUseCase = new GetHealthStatusUseCase(() => mockTimestamp);
    healthController = new HealthController(getHealthStatusUseCase);
    healthRouter = new HealthRouter(healthController);

    app = express();
    app.use('/healthz', healthRouter.getRouter());
  });

  it('should return health status with 200 OK', async () => {
    const mockHealthResponse: HealthResponse = {
      status: 200,
      timestamp: new Date().toISOString(),
      message: 'OK',
    };

    jest.spyOn(getHealthStatusUseCase, 'execute').mockReturnValue(mockHealthResponse);

    const response = await request(app).get('/healthz');

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockHealthResponse);
  });
});
