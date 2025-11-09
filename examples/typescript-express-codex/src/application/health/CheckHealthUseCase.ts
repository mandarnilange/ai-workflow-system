import { HealthStatus } from '../../domain/health/HealthStatus';
import { SystemInfoGateway } from '../../domain/health/SystemInfoGateway';

export interface HealthCheckPort {
  execute(): Promise<HealthStatus>;
}

export class CheckHealthUseCase implements HealthCheckPort {
  constructor(private readonly systemInfoGateway: SystemInfoGateway) {}

  async execute(): Promise<HealthStatus> {
    const serverIp = await this.systemInfoGateway.getServerIp();

    return new HealthStatus({
      httpStatus: 200,
      serverIp,
      message: 'Service is healthy'
    });
  }
}
