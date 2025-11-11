import { Request, Response } from 'express';
import { GetUsersUseCase } from '../../application/users/GetUsersUseCase';

export class UsersController {
  constructor(private getUsersUseCase: GetUsersUseCase) {}

  getUsers(req: Request, res: Response): void {
    const users = this.getUsersUseCase.execute();
    res.json(users);
  }
}
