export interface User {
  id: string;
  name: string;
  email: string;
}

export class GetUsers {
  execute(): User[] {
    return [
      { id: '1', name: 'Alice Johnson', email: 'alice@example.com' },
      { id: '2', name: 'Bob Smith', email: 'bob@example.com' },
      { id: '3', name: 'Charlie Davis', email: 'charlie@example.com' }
    ];
  }
}
