import { User } from './GetUsers';

export class GetUserById {
  private users: User[] = [
    { id: '1', name: 'Alice Johnson', email: 'alice@example.com' },
    { id: '2', name: 'Bob Smith', email: 'bob@example.com' },
    { id: '3', name: 'Charlie Davis', email: 'charlie@example.com' }
  ];

  execute(id: string): User | null {
    if (!id) {
      return null;
    }

    const user = this.users.find(u => u.id === id);
    return user || null;
  }
}
