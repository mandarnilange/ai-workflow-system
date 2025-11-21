import { GetUserByIdUseCase, UserNotFoundError } from '../../../src/application/users/GetUserByIdUseCase';
import { UsersRepository } from '../../../src/application/users/ListUsersUseCase';
import { User } from '../../../src/domain/users/User';

describe('GetUserByIdUseCase', () => {
  const demoUser = new User({
    id: 'user-1',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    role: 'member'
  });

  const findById = jest.fn();
  const repository: UsersRepository = {
    list: jest.fn(),
    findById
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should return user JSON when repository finds a user', async () => {
    findById.mockResolvedValue(demoUser);
    const useCase = new GetUserByIdUseCase(repository);

    const result = await useCase.execute('user-1');

    expect(findById).toHaveBeenCalledWith('user-1');
    expect(result).toEqual(demoUser.toJSON());
  });

  it('should throw UserNotFoundError when repository returns undefined', async () => {
    findById.mockResolvedValue(undefined);
    const useCase = new GetUserByIdUseCase(repository);

    await expect(useCase.execute('missing')).rejects.toThrow(UserNotFoundError);
    expect(findById).toHaveBeenCalledWith('missing');
  });

  it('should throw when repository does not implement findById', async () => {
    const repoWithoutFind: UsersRepository = {
      list: jest.fn()
    };
    const useCase = new GetUserByIdUseCase(repoWithoutFind);

    await expect(useCase.execute('user-1')).rejects.toThrow(
      'UsersRepository missing findById implementation'
    );
  });
});
