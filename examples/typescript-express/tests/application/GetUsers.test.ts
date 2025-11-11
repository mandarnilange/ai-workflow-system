import { GetUsers } from '../../src/application/GetUsers';

describe('GetUsers', () => {
  it('should return array of mock users with id, name, and email', () => {
    // Arrange
    const getUsers = new GetUsers();

    // Act
    const result = getUsers.execute();

    // Assert
    expect(Array.isArray(result)).toBe(true);
    expect(result.length).toBeGreaterThan(0);

    // Verify each user has required properties
    result.forEach((user: { id: string; name: string; email: string }) => {
      expect(user).toHaveProperty('id');
      expect(user).toHaveProperty('name');
      expect(user).toHaveProperty('email');
      expect(typeof user.id).toBe('string');
      expect(typeof user.name).toBe('string');
      expect(typeof user.email).toBe('string');
    });
  });

  it('should return at least 3 mock users', () => {
    // Arrange
    const getUsers = new GetUsers();

    // Act
    const result = getUsers.execute();

    // Assert
    expect(result.length).toBeGreaterThanOrEqual(3);
  });
});
