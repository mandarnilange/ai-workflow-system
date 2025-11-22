import { GetUserById } from '../../src/application/GetUserById';

describe('GetUserById', () => {
  let getUserById: GetUserById;

  beforeEach(() => {
    getUserById = new GetUserById();
  });

  it('should return user when valid ID is provided', () => {
    // Arrange
    const userId = '1';

    // Act
    const result = getUserById.execute(userId);

    // Assert
    expect(result).toEqual({
      id: '1',
      name: 'Alice Johnson',
      email: 'alice@example.com'
    });
  });

  it('should return null when user is not found', () => {
    // Arrange
    const userId = '999';

    // Act
    const result = getUserById.execute(userId);

    // Assert
    expect(result).toBeNull();
  });

  it('should return null when empty string ID is provided', () => {
    // Arrange
    const userId = '';

    // Act
    const result = getUserById.execute(userId);

    // Assert
    expect(result).toBeNull();
  });
});
