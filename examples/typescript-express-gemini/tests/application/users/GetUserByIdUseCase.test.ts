import { GetUserByIdUseCase } from '../../../src/application/users/GetUserByIdUseCase';
import { User } from '../../../src/domain/users/User';

describe('GetUserByIdUseCase', () => {
  let useCase: GetUserByIdUseCase;
  let mockUsers: User[];

  beforeEach(() => {
    mockUsers = [
      { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
      { id: 2, name: 'Jane Doe', email: 'jane.doe@example.com' },
    ];
    useCase = new GetUserByIdUseCase(); // Will need to inject mock data or a repository later
  });

  it('should return a user when a valid ID is provided', () => {
    const userId = 1;
    const user = useCase.execute(userId);
    expect(user).toEqual(mockUsers[0]);
  });

  it('should return undefined when an invalid ID is provided', () => {
    const userId = 999;
    const user = useCase.execute(userId);
    expect(user).toBeUndefined();
  });

  it('should return undefined when ID is not a number', () => {
    const userId = NaN; // Simulate non-numeric input via parseInt
    const user = useCase.execute(userId);
    expect(user).toBeUndefined();
  });
});
