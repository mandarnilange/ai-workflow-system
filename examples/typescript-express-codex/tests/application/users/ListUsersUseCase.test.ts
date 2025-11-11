import { ListUsersUseCase, UsersRepository } from '../../../src/application/users/ListUsersUseCase';
import { User } from '../../../src/domain/users/User';

describe('ListUsersUseCase', () => {
  const demoUsers = [
    new User({
      id: 'user-1',
      name: 'Jane Doe',
      email: 'jane.doe@example.com',
      role: 'member'
    })
  ];

  const list = jest.fn().mockResolvedValue(demoUsers);
  const repository: UsersRepository = {
    list
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should return users from repository as JSON', async () => {
    const useCase = new ListUsersUseCase(repository);

    const result = await useCase.execute();

    expect(list).toHaveBeenCalledTimes(1);
    expect(result).toEqual(demoUsers.map((user) => user.toJSON()));
  });
});
