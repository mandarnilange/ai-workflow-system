import { InMemoryUsersRepository } from '../../../src/infrastructure/users/InMemoryUsersRepository';
import { userFixtures } from '../../../src/domain/users/userFixtures';
import { User } from '../../../src/domain/users/User';

describe('InMemoryUsersRepository', () => {
  it('should return fixture users as domain objects', async () => {
    const repository = new InMemoryUsersRepository();

    const result = await repository.list();

    const expected = userFixtures.list().map((user) => user.toJSON());
    expect(result.map((user: User) => user.toJSON())).toEqual(expected);
  });

  it('should find a user by id when fixtures contain it', async () => {
    const repository = new InMemoryUsersRepository();

    const result = await repository.findById('user-1');

    expect(result).toBeInstanceOf(User);
    expect(result?.toJSON()).toMatchObject({
      id: 'user-1',
      name: 'Jane Doe'
    });
  });

  it('should return undefined when user id is unknown', async () => {
    const repository = new InMemoryUsersRepository();

    const result = await repository.findById('missing');

    expect(result).toBeUndefined();
  });
});
