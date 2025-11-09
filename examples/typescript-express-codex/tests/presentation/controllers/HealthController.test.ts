import { Request, Response } from 'express';
import { HealthCheckPort } from '../../../src/application/health/CheckHealthUseCase';
import { HealthController } from '../../../src/presentation/controllers/HealthController';
import { HealthStatus } from '../../../src/domain/health/HealthStatus';

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

describe('HealthController', () => {
  it('should respond with JSON payload from use case result', async () => {
    const healthStatus = new HealthStatus({
      httpStatus: 200,
      serverIp: '192.168.1.10',
      message: 'OK'
    });

    const execute = jest.fn().mockResolvedValue(healthStatus);
    const useCase: HealthCheckPort = {
      execute
    };

    const controller = new HealthController(useCase);
    const req = {} as Request;
    const res = buildResponse();

    await controller.handle(req, res as unknown as Response);

    const { status, json } = res;
    const statusSpy = status;
    const jsonSpy = json;

    expect(execute).toHaveBeenCalledTimes(1);
    expect(statusSpy).toHaveBeenCalledWith(200);
    expect(jsonSpy).toHaveBeenCalledWith({
      httpStatus: 200,
      serverIp: '192.168.1.10',
      message: 'OK'
    });
  });
});
