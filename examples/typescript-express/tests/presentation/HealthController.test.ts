import { Request, Response } from 'express';
import { HealthController } from '../../src/presentation/HealthController';
import { GetHealthStatus } from '../../src/application/GetHealthStatus';

describe('HealthController', () => {
  it('should return 200 OK with health status', () => {
    // Arrange
    const mockGetHealthStatus = {
      execute: jest.fn().mockReturnValue({
        status: 'ok',
        message: 'Service is healthy',
        timestamp: new Date('2025-01-01T00:00:00.000Z')
      })
    } as unknown as GetHealthStatus;

    const controller = new HealthController(mockGetHealthStatus);

    const mockRequest = {} as Request;
    const mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    } as unknown as Response;

    // Act
    controller.getHealth(mockRequest, mockResponse);

    // Assert
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      status: 'ok',
      message: 'Service is healthy',
      timestamp: new Date('2025-01-01T00:00:00.000Z')
    });
    expect(mockGetHealthStatus.execute).toHaveBeenCalledTimes(1);
  });
});
