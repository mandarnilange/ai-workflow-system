import { User } from '../../../src/domain/users/User';
import { userFixtures } from '../../../src/domain/users/userFixtures';

describe('userFixtures', () => {
  it('should return a stable list of demo users', () => {
    const users = userFixtures.list();

    expect(users).toHaveLength(2);
    users.forEach((user) => expect(user).toBeInstanceOf(User));
  });

  it('should expose plain JSON when requested', () => {
    const payload = userFixtures.asJson();

    expect(payload).toEqual([
      {
        id: 'user-1',
        name: 'Jane Doe',
        email: 'jane.doe@example.com',
        role: 'member'
      },
      {
        id: 'user-2',
        name: 'John Smith',
        email: 'john.smith@example.com',
        role: 'admin'
      }
    ]);
  });
});
