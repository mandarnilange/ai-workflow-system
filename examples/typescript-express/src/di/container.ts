import { GetHealthStatus } from '../application/GetHealthStatus';
import { HealthController } from '../presentation/HealthController';

export interface Container {
  getHealthStatus: GetHealthStatus;
  healthController: HealthController;
}

export function createContainer(): Container {
  // Application Layer
  const getHealthStatus = new GetHealthStatus();

  // Presentation Layer
  const healthController = new HealthController(getHealthStatus);

  return {
    getHealthStatus,
    healthController
  };
}
