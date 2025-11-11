import { User } from './User';

const demoUsers = [
  new User({
    id: 'user-1',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    role: 'member'
  }),
  new User({
    id: 'user-2',
    name: 'John Smith',
    email: 'john.smith@example.com',
    role: 'admin'
  })
];

export const userFixtures = {
  list(): User[] {
    return demoUsers.map((user) => new User(user.toJSON()));
  },
  asJson() {
    return demoUsers.map((user) => user.toJSON());
  }
};
