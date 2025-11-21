import { Request, Response } from 'express';
import { UsersController } from '../../../src/presentation/controllers/UsersController';
import { userFixtures } from '../../../src/domain/users/userFixtures';
import { ListUsersPort } from '../../../src/application/users/ListUsersUseCase';
import { GetUserByIdPort } from '../../../src/application/users/GetUserByIdUseCase';
import { UserNotFoundError } from '../../../src/application/users/GetUserByIdUseCase';

type ResponseMock = {
  statusCode?: number;
  body?: unknown;
  status: jest.Mock;
  json: jest.Mock;
};

const buildResponse = (): ResponseMock => {
  const res: ResponseMock = {
    status: jest.fn().mockImplementation((code: number) => {
      res.statusCode = code;
      return res;
    }),
    json: jest.fn().mockImplementation((payload: unknown) => {
      res.body = payload;
      return res;
    })
  };

  return res;
};

describe('UsersController', () => {
  it('should respond with JSON payload from user list use case', async () => {
    const payload = userFixtures.asJson();
    const execute = jest.fn().mockResolvedValue(payload);
    const listUseCase: ListUsersPort = {
      execute
    };

    const controller = new UsersController(listUseCase, {} as GetUserByIdPort);
    const req = {} as Request;
    const res = buildResponse();

    await controller.handle(req, res as unknown as Response);

    expect(execute).toHaveBeenCalledTimes(1);
    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({
      users: payload
    });
  });

  it('should return single user when get user use case resolves', async () => {
    const payload = userFixtures.asJson()[0];
    const getUserExecute = jest.fn().mockResolvedValue(payload);
    const controller = new UsersController(
      {} as ListUsersPort,
      { execute: getUserExecute }
    );
    const req = { params: { id: payload.id } } as unknown as Request;
    const res = buildResponse();

    await controller.show(req, res as unknown as Response);

    expect(getUserExecute).toHaveBeenCalledWith(payload.id);
    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({ user: payload });
  });

  it('should respond with 404 when user detail use case throws not found', async () => {
    const getUserExecute = jest
      .fn()
      .mockRejectedValue(new UserNotFoundError('missing'));
    const controller = new UsersController(
      {} as ListUsersPort,
      { execute: getUserExecute }
    );
    const req = { params: { id: 'missing' } } as unknown as Request;
    const res = buildResponse();

    await controller.show(req, res as unknown as Response);

    expect(res.status).toHaveBeenCalledWith(404);
    expect(res.json).toHaveBeenCalledWith({
      error: 'User missing not found'
    });
  });
});
