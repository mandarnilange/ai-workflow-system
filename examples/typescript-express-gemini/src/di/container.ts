import { GetHealthStatusUseCase } from '../application/health/GetHealthStatusUseCase';
import { HealthController } from '../presentation/health/HealthController';
import { HealthRouter } from '../presentation/health/HealthRouter';
import { GetUsersUseCase } from '../application/users/GetUsersUseCase';
import { UsersController } from '../presentation/users/UsersController';
import { UsersRouter } from '../presentation/users/UsersRouter';

// Use Cases
const getHealthStatusUseCase = new GetHealthStatusUseCase();
const getUsersUseCase = new GetUsersUseCase();

// Controllers
const healthController = new HealthController(getHealthStatusUseCase);
const usersController = new UsersController(getUsersUseCase);

// Routers
const healthRouter = new HealthRouter(healthController);
const usersRouter = new UsersRouter(usersController);

export {
  getHealthStatusUseCase,
  healthController,
  healthRouter,
  getUsersUseCase,
  usersController,
  usersRouter,
};
