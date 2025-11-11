import { userFixtures } from '../../domain/users/userFixtures';
import { User } from '../../domain/users/User';
import { UsersRepository } from '../../application/users/ListUsersUseCase';

export class InMemoryUsersRepository implements UsersRepository {
  list(): Promise<User[]> {
    return Promise.resolve(userFixtures.list());
  }
}
