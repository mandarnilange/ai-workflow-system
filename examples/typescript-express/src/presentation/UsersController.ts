import { Request, Response } from 'express';
import { GetUsers } from '../application/GetUsers';

export class UsersController {
  constructor(private readonly getUsersUseCase: GetUsers) {}

  getUsers(_req: Request, res: Response): void {
    const users = this.getUsersUseCase.execute();
    res.status(200).json(users);
  }
}
