import { Request, Response } from 'express';
import { UsersController } from '../../src/presentation/UsersController';
import { GetUsers } from '../../src/application/GetUsers';
import { GetUserById } from '../../src/application/GetUserById';

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

  describe('getUserById', () => {
    it('should return 200 OK with user when user exists', () => {
      // Arrange
      const mockUser = { id: '1', name: 'Alice Johnson', email: 'alice@example.com' };

      const mockGetUsers = {} as GetUsers;
      const mockGetUserById = {
        execute: jest.fn().mockReturnValue(mockUser)
      } as unknown as GetUserById;

      const controller = new UsersController(mockGetUsers, mockGetUserById);

      const mockRequest = {
        params: { id: '1' }
      } as unknown as Request;

      const mockResponse = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      } as unknown as Response;

      // Act
      controller.getUserById(mockRequest, mockResponse);

      // Assert
      expect(mockResponse.status).toHaveBeenCalledWith(200);
      expect(mockResponse.json).toHaveBeenCalledWith(mockUser);
      expect(mockGetUserById.execute).toHaveBeenCalledWith('1');
    });

    it('should return 404 when user is not found', () => {
      // Arrange
      const mockGetUsers = {} as GetUsers;
      const mockGetUserById = {
        execute: jest.fn().mockReturnValue(null)
      } as unknown as GetUserById;

      const controller = new UsersController(mockGetUsers, mockGetUserById);

      const mockRequest = {
        params: { id: '999' }
      } as unknown as Request;

      const mockResponse = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      } as unknown as Response;

      // Act
      controller.getUserById(mockRequest, mockResponse);

      // Assert
      expect(mockResponse.status).toHaveBeenCalledWith(404);
      expect(mockResponse.json).toHaveBeenCalledWith({
        error: 'User not found'
      });
      expect(mockGetUserById.execute).toHaveBeenCalledWith('999');
    });
  });
});
