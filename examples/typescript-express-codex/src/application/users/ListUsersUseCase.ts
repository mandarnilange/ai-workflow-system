import { User, UserProps } from '../../domain/users/User';

export interface UsersRepository {
  list(): Promise<User[]>;
  findById?(id: string): Promise<User | undefined>;
}

export interface ListUsersPort {
  execute(): Promise<UserProps[]>;
}

export class ListUsersUseCase implements ListUsersPort {
  constructor(private readonly usersRepository: UsersRepository) {}

  async execute(): Promise<UserProps[]> {
    const users = await this.usersRepository.list();
    return users.map((user) => user.toJSON());
  }
}
