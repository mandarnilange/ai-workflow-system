import { User } from '../../domain/users/User';

export class GetUserByIdUseCase {
  execute(id: number): User | undefined {
    const users: User[] = [
      { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
      { id: 2, name: 'Jane Doe', email: 'jane.doe@example.com' },
    ];
    if (typeof id !== 'number') {
      return undefined;
    }
    return users.find(user => user.id === id);
  }
}
