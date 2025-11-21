import { EventEmitter } from 'events';
import { createRequest, createResponse } from 'node-mocks-http';
import { Request, Response, NextFunction } from 'express';
import { buildApp } from '../../../src/presentation/server';
import { UsersController } from '../../../src/presentation/controllers/UsersController';
import { ListUsersPort } from '../../../src/application/users/ListUsersUseCase';
import { userFixtures } from '../../../src/domain/users/userFixtures';
import { HealthController } from '../../../src/presentation/controllers/HealthController';
import { HealthCheckPort } from '../../../src/application/health/CheckHealthUseCase';
import { AppContainer } from '../../../src/di/container';
import { GetUserByIdPort, UserNotFoundError } from '../../../src/application/users/GetUserByIdUseCase';

describe('users routes', () => {
  it('should return mock users for GET /api/users', async () => {
    const payload = userFixtures.asJson();
    const usersUseCase: ListUsersPort = {
      execute: jest.fn().mockResolvedValue(payload)
    };

    const getUserUseCase: GetUserByIdPort = {
      execute: jest.fn()
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
      usersController: new UsersController(usersUseCase, getUserUseCase)
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

  it('should propagate errors for GET /api/users through next()', async () => {
    const listPort: ListUsersPort = {
      execute: jest.fn().mockRejectedValue(new Error('boom'))
    };
    const getUserUseCase: GetUserByIdPort = {
      execute: jest.fn()
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
      usersController: new UsersController(listPort, getUserUseCase)
    };
    const app = buildApp(container);

    app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
      void _next;
      res.status(500).json({ message: err.message });
    });

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

    expect(res.statusCode).toBe(500);
    expect(res._getJSONData()).toEqual({ message: 'boom' });
  });

  it('should return a single user on GET /api/users/:id when found', async () => {
    const payload = userFixtures.asJson()[0];
    const listPort: ListUsersPort = { execute: jest.fn() };
    const getUserUseCase: GetUserByIdPort = {
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
      usersController: new UsersController(listPort, getUserUseCase)
    };
    const app = buildApp(container);
    const req = createRequest({
      method: 'GET',
      url: `/api/users/${payload.id}`
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
    expect(res._getJSONData()).toEqual({ user: payload });
  });

  it('should return 404 JSON when GET /api/users/:id not found', async () => {
    const listPort: ListUsersPort = { execute: jest.fn() };
    const getUserUseCase: GetUserByIdPort = {
      execute: jest.fn().mockRejectedValue(new UserNotFoundError('missing'))
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
      usersController: new UsersController(listPort, getUserUseCase)
    };
    const app = buildApp(container);
    const req = createRequest({
      method: 'GET',
      url: '/api/users/missing'
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

    expect(res.statusCode).toBe(404);
    expect(res._getJSONData()).toEqual({ error: 'User missing not found' });
  });

  it('should propagate errors for GET /api/users/:id through next()', async () => {
    const listPort: ListUsersPort = {
      execute: jest.fn()
    };
    const getUserUseCase: GetUserByIdPort = {
      execute: jest.fn().mockRejectedValue(new Error('kaboom'))
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
      usersController: new UsersController(listPort, getUserUseCase)
    };
    const app = buildApp(container);

    app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
      void _next;
      res.status(500).json({ message: err.message });
    });

    const req = createRequest({
      method: 'GET',
      url: '/api/users/user-123'
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
    expect(res._getJSONData()).toEqual({ message: 'kaboom' });
  });
});
