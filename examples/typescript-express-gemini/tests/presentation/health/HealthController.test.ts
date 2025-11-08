import { Request, Response } from 'express';
import { GetHealthStatusUseCase } from '../../../src/application/health/GetHealthStatusUseCase';
import { HealthController } from '../../../src/presentation/health/HealthController';
import { HealthResponse } from '../../../src/domain/health/HealthResponse';

describe('HealthController', () => {
  let getHealthStatusUseCase: GetHealthStatusUseCase;
  let healthController: HealthController;
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;

  beforeEach(() => {
    const mockTimestamp = '2025-11-08T12:00:00.000Z';
    getHealthStatusUseCase = new GetHealthStatusUseCase(() => mockTimestamp);
    healthController = new HealthController(getHealthStatusUseCase);
    mockRequest = {};
    mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  it('should return health status with 200 OK', () => {
    const mockHealthResponse: HealthResponse = {
      status: 200,
      timestamp: new Date().toISOString(),
      message: 'OK',
    };

    jest.spyOn(getHealthStatusUseCase, 'execute').mockReturnValue(mockHealthResponse);

    healthController.getHealthStatus(mockRequest as Request, mockResponse as Response);

    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith(mockHealthResponse);
  });
});
