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
});
