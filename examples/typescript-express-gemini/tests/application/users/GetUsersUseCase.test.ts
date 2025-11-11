import { GetUsersUseCase } from '../../../src/application/users/GetUsersUseCase';
import { User } from '../../../src/domain/users/User';

describe('GetUsersUseCase', () => {
  it('should return a list of users', () => {
    // Arrange
    const useCase = new GetUsersUseCase();
    const expectedUsers: User[] = [
      { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
      { id: 2, name: 'Jane Doe', email: 'jane.doe@example.com' },
    ];

    // Act
    const users = useCase.execute();

    // Assert
    expect(users).toEqual(expectedUsers);
  });
});
