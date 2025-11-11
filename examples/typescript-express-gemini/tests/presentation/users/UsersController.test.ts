import { GetUsersUseCase } from '../../../src/application/users/GetUsersUseCase';
import { UsersController } from '../../../src/presentation/users/UsersController';
import { User } from '../../../src/domain/users/User';
import { Request, Response } from 'express';

describe('UsersController', () => {
  let getUsersUseCase: GetUsersUseCase;
  let usersController: UsersController;
  let req: Partial<Request>;
  let res: Partial<Response>;
  let jsonMock: jest.Mock;

  beforeEach(() => {
    getUsersUseCase = new GetUsersUseCase();
    usersController = new UsersController(getUsersUseCase);
    jsonMock = jest.fn();
    req = {};
    res = {
      json: jsonMock,
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
});
