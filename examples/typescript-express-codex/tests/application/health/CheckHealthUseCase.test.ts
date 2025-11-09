import { CheckHealthUseCase } from '../../../src/application/health/CheckHealthUseCase';
import { SystemInfoGateway } from '../../../src/domain/health/SystemInfoGateway';

describe('CheckHealthUseCase', () => {
  it('should return HealthStatus with gateway IP and default payload', async () => {
    const getServerIp = jest.fn().mockResolvedValue('10.0.0.5');
    const gateway: SystemInfoGateway = {
      getServerIp
    };

    const useCase = new CheckHealthUseCase(gateway);

    const result = await useCase.execute();

    expect(result.toJSON()).toEqual({
      httpStatus: 200,
      serverIp: '10.0.0.5',
      message: 'Service is healthy'
    });

    expect(getServerIp).toHaveBeenCalledTimes(1);
  });
});
