import { GetHealthStatusUseCase } from '../application/health/GetHealthStatusUseCase';
import { HealthController } from '../presentation/health/HealthController';
import { HealthRouter } from '../presentation/health/HealthRouter';

// Use Cases
const getHealthStatusUseCase = new GetHealthStatusUseCase();

// Controllers
const healthController = new HealthController(getHealthStatusUseCase);

// Routers
const healthRouter = new HealthRouter(healthController);

export {
  getHealthStatusUseCase,
  healthController,
  healthRouter,
};
