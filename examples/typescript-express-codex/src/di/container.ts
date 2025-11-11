import { HealthController } from '../presentation/controllers/HealthController';
import { CheckHealthUseCase } from '../application/health/CheckHealthUseCase';
import { OsSystemInfoGateway } from '../infrastructure/system/OsSystemInfoGateway';
import { UsersController } from '../presentation/controllers/UsersController';
import { ListUsersUseCase } from '../application/users/ListUsersUseCase';
import { InMemoryUsersRepository } from '../infrastructure/users';

export type AppContainer = {
  healthController: HealthController;
  usersController: UsersController;
};

export const createContainer = (): AppContainer => {
  const systemInfoGateway = new OsSystemInfoGateway();
  const checkHealthUseCase = new CheckHealthUseCase(systemInfoGateway);
  const healthController = new HealthController(checkHealthUseCase);
  const usersRepository = new InMemoryUsersRepository();
  const listUsersUseCase = new ListUsersUseCase(usersRepository);
  const usersController = new UsersController(listUsersUseCase);

  return { healthController, usersController };
};
