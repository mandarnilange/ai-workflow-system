import { Request, Response } from 'express';
import { ListUsersPort } from '../../application/users/ListUsersUseCase';

export class UsersController {
  constructor(private readonly listUsersUseCase: ListUsersPort) {}

  async handle(_req: Request, res: Response): Promise<Response> {
    const users = await this.listUsersUseCase.execute();
    return res.status(200).json({ users });
  }
}
