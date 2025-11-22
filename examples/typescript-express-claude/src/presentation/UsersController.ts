import { Request, Response } from 'express';
import { GetUsers } from '../application/GetUsers';
import { GetUserById } from '../application/GetUserById';

export class UsersController {
  constructor(
    private readonly getUsersUseCase: GetUsers,
    private readonly getUserByIdUseCase?: GetUserById
  ) {}

  getUsers(_req: Request, res: Response): void {
    const users = this.getUsersUseCase.execute();
    res.status(200).json(users);
  }

  getUserById(req: Request, res: Response): void {
    const { id } = req.params;
    const user = this.getUserByIdUseCase?.execute(id);

    if (!user) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    res.status(200).json(user);
  }
}
