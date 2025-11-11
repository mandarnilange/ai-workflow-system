import { Request, Response } from 'express';
import { createContainer } from '../../src/di/container';
import { userFixtures } from '../../src/domain/users/userFixtures';

describe('DI container', () => {
  it('should wire health controller dependencies', async () => {
    const container = createContainer();
    const response: Partial<Response> = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis()
    };

    await container.healthController.handle({} as Request, response as Response);

    expect(response.status).toHaveBeenCalledWith(200);
    expect(response.json).toHaveBeenCalledWith(
      expect.objectContaining({
        httpStatus: 200,
        message: 'Service is healthy'
      })
    );
  });

  it('should wire users controller dependencies', async () => {
    const container = createContainer();
    const response: Partial<Response> = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis()
    };

    await container.usersController.handle({} as Request, response as Response);

    expect(response.status).toHaveBeenCalledWith(200);
    expect(response.json).toHaveBeenCalledWith({
      users: userFixtures.asJson()
    });
  });
});
