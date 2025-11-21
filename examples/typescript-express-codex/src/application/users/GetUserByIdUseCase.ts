import { UserProps } from '../../domain/users/User';
import { UsersRepository } from './ListUsersUseCase';

export class UserNotFoundError extends Error {
  constructor(id: string) {
    super(`User with id ${id} was not found`);
  }
}

export interface GetUserByIdPort {
  execute(id: string): Promise<UserProps>;
}

export class GetUserByIdUseCase implements GetUserByIdPort {
  constructor(private readonly usersRepository: UsersRepository) {}

  async execute(id: string): Promise<UserProps> {
    if (!this.usersRepository.findById) {
      throw new Error('UsersRepository missing findById implementation');
    }

    const user = await this.usersRepository.findById(id);

    if (!user) {
      throw new UserNotFoundError(id);
    }

    return user.toJSON();
  }
}
