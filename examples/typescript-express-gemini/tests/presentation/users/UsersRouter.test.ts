import request from 'supertest';
import express from 'express';
import { UsersController } from '../../../src/presentation/users/UsersController';
import { GetUsersUseCase } from '../../../src/application/users/GetUsersUseCase';
import { User } from '../../../src/domain/users/User';
import { UsersRouter } from '../../../src/presentation/users/UsersRouter';
import { GetUserByIdUseCase } from '../../../src/application/users/GetUserByIdUseCase';

describe('Users Routes', () => {
  let app: express.Application;
  let getUsersUseCase: GetUsersUseCase;
  let getUserByIdUseCase: jest.Mocked<GetUserByIdUseCase>;
  let usersController: UsersController;
  let usersRouter: UsersRouter;

  beforeAll(() => {
    getUsersUseCase = new GetUsersUseCase();
    getUserByIdUseCase = {
      execute: jest.fn(),
    } as jest.Mocked<GetUserByIdUseCase>;
    usersController = new UsersController(getUsersUseCase, getUserByIdUseCase);
    usersRouter = new UsersRouter(usersController);

    app = express();
    app.use('/api', usersRouter.getRouter());
  });

  beforeEach(() => {
    jest.clearAllMocks(); // Clear mock call history before each test
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

  it('should return 200 and a single user for GET /api/users/:id', async () => {
    const mockUser: User = { id: 1, name: 'John Doe', email: 'john.doe@example.com' };
    getUserByIdUseCase.execute.mockReturnValue(mockUser);

    const response = await request(app).get('/api/users/1');

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockUser);
    expect(getUserByIdUseCase.execute).toHaveBeenCalledWith(1);
  });

  it('should return 404 for GET /api/users/:id when user not found', async () => {
    getUserByIdUseCase.execute.mockReturnValue(undefined);

    const response = await request(app).get('/api/users/999');

    expect(response.status).toBe(404);
    expect(response.body).toEqual({ message: 'User not found' });
    expect(getUserByIdUseCase.execute).toHaveBeenCalledWith(999);
  });

  it('should return 400 for GET /api/users/:id when ID is not a number', async () => {
    const response = await request(app).get('/api/users/abc');

    expect(response.status).toBe(400);
    expect(response.body).toEqual({ message: 'Invalid user ID' });
    expect(getUserByIdUseCase.execute).not.toHaveBeenCalled();
  });
});
