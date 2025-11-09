import { HealthController } from '../presentation/controllers/HealthController';
import { CheckHealthUseCase } from '../application/health/CheckHealthUseCase';
import { OsSystemInfoGateway } from '../infrastructure/system/OsSystemInfoGateway';

export type AppContainer = {
  healthController: HealthController;
};

export const createContainer = (): AppContainer => {
  const systemInfoGateway = new OsSystemInfoGateway();
  const checkHealthUseCase = new CheckHealthUseCase(systemInfoGateway);
  const healthController = new HealthController(checkHealthUseCase);

  return { healthController };
};
