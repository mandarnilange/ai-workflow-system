import { EventEmitter } from 'events';
import { createRequest, createResponse } from 'node-mocks-http';
import { Request, Response, NextFunction } from 'express';
import { buildApp } from '../../../src/presentation/server';
import { AppContainer } from '../../../src/di/container';
import { HealthController } from '../../../src/presentation/controllers/HealthController';
import { CheckHealthUseCase, HealthCheckPort } from '../../../src/application/health/CheckHealthUseCase';

describe('health routes', () => {
  it('should return health payload for GET /health', async () => {
    const container: AppContainer = {
      healthController: new HealthController(
        new CheckHealthUseCase({
          getServerIp: jest.fn().mockResolvedValue('203.0.113.5')
        })
      )
    };

    const app = buildApp(container);
    const req = createRequest({
      method: 'GET',
      url: '/health'
    });

    const res = createResponse({
      eventEmitter: EventEmitter
    });

    const finished = new Promise<void>((resolve, reject) => {
      const done = () => resolve();
      res.on('end', done);
      res.on('finish', done);
      res.on('error', reject);
    });

    app(req, res);
    await finished;

    expect(res.statusCode).toBe(200);
    expect(res._isJSON()).toBe(true);
    expect(res._getJSONData()).toEqual({
      httpStatus: 200,
      serverIp: '203.0.113.5',
      message: 'Service is healthy'
    });
  });

  it('should forward errors from controller to error middleware', async () => {
    const failingUseCase: HealthCheckPort = {
      execute: jest.fn().mockRejectedValue(new Error('boom'))
    };

    const container: AppContainer = {
      healthController: new HealthController(failingUseCase)
    };

    const app = buildApp(container);

    app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
      void _next;
      res.status(500).json({ message: err.message });
    });

    const req = createRequest({
      method: 'GET',
      url: '/health'
    });

    const res = createResponse({
      eventEmitter: EventEmitter
    });

    const finished = new Promise<void>((resolve, reject) => {
      const done = () => resolve();
      res.on('end', done);
      res.on('finish', done);
      res.on('error', reject);
    });

    app(req, res);
    await finished;

    expect(res.statusCode).toBe(500);
    expect(res._getJSONData()).toEqual({ message: 'boom' });
  });
});
