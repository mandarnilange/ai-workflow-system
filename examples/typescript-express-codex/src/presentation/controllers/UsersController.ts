import { Request, Response } from 'express';
import { ListUsersPort } from '../../application/users/ListUsersUseCase';
import { GetUserByIdPort, UserNotFoundError } from '../../application/users/GetUserByIdUseCase';

export class UsersController {
  constructor(
    private readonly listUsersUseCase: ListUsersPort,
    private readonly getUserByIdUseCase: GetUserByIdPort
  ) {}

  async handle(_req: Request, res: Response): Promise<Response> {
    const users = await this.listUsersUseCase.execute();
    return res.status(200).json({ users });
  }

  async show(req: Request, res: Response): Promise<Response> {
    try {
      const user = await this.getUserByIdUseCase.execute(req.params.id);
      return res.status(200).json({ user });
    } catch (error) {
      if (error instanceof UserNotFoundError) {
        return res.status(404).json({ error: `User ${req.params.id} not found` });
      }
      throw error;
    }
  }
}
