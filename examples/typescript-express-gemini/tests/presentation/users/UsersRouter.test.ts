import request from 'supertest';
import express from 'express';
import { UsersController } from '../../../src/presentation/users/UsersController';
import { GetUsersUseCase } from '../../../src/application/users/GetUsersUseCase';
import { User } from '../../../src/domain/users/User';
import { UsersRouter } from '../../../src/presentation/users/UsersRouter';

describe('Users Routes', () => {
  let app: express.Application;
  let getUsersUseCase: GetUsersUseCase;
  let usersController: UsersController;
  let usersRouter: UsersRouter;

  beforeAll(() => {
    getUsersUseCase = new GetUsersUseCase();
    usersController = new UsersController(getUsersUseCase);
    usersRouter = new UsersRouter(usersController);

    app = express();
    app.use('/api', usersRouter.getRouter());
  });

  it('should return a list of users with 200 OK', async () => {
    const mockUsers: User[] = [
      { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
      { id: 2, name: 'Jane Doe', email: 'jane.doe@example.com' },
    ];

    jest.spyOn(getUsersUseCase, 'execute').mockReturnValue(mockUsers);

    const response = await request(app).get('/api/users');

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockUsers);
  });
});
