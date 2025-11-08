import { GetHealthStatus } from '../../src/application/GetHealthStatus';

describe('GetHealthStatus', () => {
  it('should return health status with timestamp and message', () => {
    // Arrange
    const getHealthStatus = new GetHealthStatus();

    // Act
    const result = getHealthStatus.execute();

    // Assert
    expect(result.status).toBe('ok');
    expect(result.message).toBe('Service is healthy');
    expect(result.timestamp).toBeInstanceOf(Date);
  });
});
