import { GetUsersUseCase } from '../../../src/application/users/GetUsersUseCase';
import { UsersController } from '../../../src/presentation/users/UsersController';
import { User } from '../../../src/domain/users/User';
import { Request, Response } from 'express';
import { GetUserByIdUseCase } from '../../../src/application/users/GetUserByIdUseCase';

describe('UsersController', () => {
  let getUsersUseCase: GetUsersUseCase;
  let getUserByIdUseCase: jest.Mocked<GetUserByIdUseCase>;
  let usersController: UsersController;
  let req: Partial<Request>;
  let res: Partial<Response>;
  let jsonMock: jest.Mock;
  let statusMock: jest.Mock;

  beforeEach(() => {
    getUsersUseCase = new GetUsersUseCase();
    getUserByIdUseCase = {
      execute: jest.fn(),
    } as jest.Mocked<GetUserByIdUseCase>; // Mock the use case
    usersController = new UsersController(getUsersUseCase, getUserByIdUseCase);
    jsonMock = jest.fn();
    statusMock = jest.fn(() => res); // Allow chaining .status().json()
    req = {};
    res = {
      json: jsonMock,
      status: statusMock,
    };
  });

  it('should get users and return them as json', () => {
    // Arrange
    const expectedUsers: User[] = [
      { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
      { id: 2, name: 'Jane Doe', email: 'jane.doe@example.com' },
    ];
    jest.spyOn(getUsersUseCase, 'execute').mockReturnValue(expectedUsers);

    // Act
    usersController.getUsers(req as Request, res as Response);

    // Assert
    expect(getUsersUseCase.execute).toHaveBeenCalledTimes(1);
    expect(jsonMock).toHaveBeenCalledWith(expectedUsers);
  });

  it('should return 200 and the user when a valid ID is provided', () => {
    // Arrange
    const expectedUser: User = { id: 1, name: 'John Doe', email: 'john.doe@example.com' };
    getUserByIdUseCase.execute.mockReturnValue(expectedUser); // Use mocked method
    req.params = { id: '1' };

    // Act
    usersController.getUserById(req as Request, res as Response);

    // Assert
    expect(getUserByIdUseCase.execute).toHaveBeenCalledWith(1);
    expect(statusMock).toHaveBeenCalledWith(200);
    expect(jsonMock).toHaveBeenCalledWith(expectedUser);
  });

  it('should return 404 when an invalid ID is provided', () => {
    // Arrange
    getUserByIdUseCase.execute.mockReturnValue(undefined); // Use mocked method
    req.params = { id: '999' };

    // Act
    usersController.getUserById(req as Request, res as Response);

    // Assert
    expect(getUserByIdUseCase.execute).toHaveBeenCalledWith(999);
    expect(statusMock).toHaveBeenCalledWith(404);
    expect(jsonMock).toHaveBeenCalledWith({ message: 'User not found' });
  });

  it('should return 400 when ID is not a number', () => {
    // Arrange
    req.params = { id: 'abc' };

    // Act
    usersController.getUserById(req as Request, res as Response);

    // Assert
    expect(statusMock).toHaveBeenCalledWith(400);
    expect(jsonMock).toHaveBeenCalledWith({ message: 'Invalid user ID' });
    expect(getUserByIdUseCase.execute).not.toHaveBeenCalled(); // Ensure use case is not called with invalid input
  });
});
