import { EventEmitter } from 'events';
import { createRequest, createResponse } from 'node-mocks-http';
import { buildApp } from '../../../src/presentation/server';
import { UsersController } from '../../../src/presentation/controllers/UsersController';
import { ListUsersPort } from '../../../src/application/users/ListUsersUseCase';
import { userFixtures } from '../../../src/domain/users/userFixtures';
import { HealthController } from '../../../src/presentation/controllers/HealthController';
import { HealthCheckPort } from '../../../src/application/health/CheckHealthUseCase';
import { AppContainer } from '../../../src/di/container';

describe('users routes', () => {
  it('should return mock users for GET /api/users', async () => {
    const payload = userFixtures.asJson();
    const usersUseCase: ListUsersPort = {
      execute: jest.fn().mockResolvedValue(payload)
    };

    const healthUseCase: HealthCheckPort = {
      execute: jest.fn().mockResolvedValue({
        toJSON: () => ({
          httpStatus: 200,
          serverIp: '127.0.0.1',
          message: 'OK'
        })
      })
    };

    const container: AppContainer = {
      healthController: new HealthController(healthUseCase),
      usersController: new UsersController(usersUseCase)
    };

    const app = buildApp(container);

    const req = createRequest({
      method: 'GET',
      url: '/api/users'
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
    expect(res._getJSONData()).toEqual({ users: payload });
  });
});
