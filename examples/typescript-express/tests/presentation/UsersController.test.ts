import { Request, Response } from 'express';
import { UsersController } from '../../src/presentation/UsersController';
import { GetUsers } from '../../src/application/GetUsers';

describe('UsersController', () => {
  it('should return 200 OK with users array', () => {
    // Arrange
    const mockUsers = [
      { id: '1', name: 'Alice Johnson', email: 'alice@example.com' },
      { id: '2', name: 'Bob Smith', email: 'bob@example.com' },
      { id: '3', name: 'Charlie Davis', email: 'charlie@example.com' }
    ];

    const mockGetUsers = {
      execute: jest.fn().mockReturnValue(mockUsers)
    } as unknown as GetUsers;

    const controller = new UsersController(mockGetUsers);

    const mockRequest = {} as Request;
    const mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    } as unknown as Response;

    // Act
    controller.getUsers(mockRequest, mockResponse);

    // Assert
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith(mockUsers);
    expect(mockGetUsers.execute).toHaveBeenCalledTimes(1);
  });
});
