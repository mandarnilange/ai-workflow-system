import { User } from '../../domain/users/User';

export class GetUsersUseCase {
  execute(): User[] {
    return [
      { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
      { id: 2, name: 'Jane Doe', email: 'jane.doe@example.com' },
    ];
  }
}
