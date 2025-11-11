import { Request, Response } from 'express';
import { UsersController } from '../../../src/presentation/controllers/UsersController';
import { userFixtures } from '../../../src/domain/users/userFixtures';
import { ListUsersPort } from '../../../src/application/users/ListUsersUseCase';

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
    const useCase: ListUsersPort = {
      execute
    };

    const controller = new UsersController(useCase);
    const req = {} as Request;
    const res = buildResponse();

    await controller.handle(req, res as unknown as Response);

    expect(execute).toHaveBeenCalledTimes(1);
    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({
      users: payload
    });
  });
});
