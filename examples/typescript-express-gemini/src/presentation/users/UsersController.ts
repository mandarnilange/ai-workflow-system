import { Request, Response } from 'express';
import { GetUsersUseCase } from '../../application/users/GetUsersUseCase';
import { GetUserByIdUseCase } from '../../application/users/GetUserByIdUseCase';

export class UsersController {
  constructor(
    private getUsersUseCase: GetUsersUseCase,
    private getUserByIdUseCase: GetUserByIdUseCase
  ) {}

  getUsers(req: Request, res: Response): void {
    const users = this.getUsersUseCase.execute();
    res.json(users);
  }

  getUserById(req: Request, res: Response): void {
    const id = parseInt(req.params.id, 10);

    if (isNaN(id)) {
      res.status(400).json({ message: 'Invalid user ID' });
      return;
    }

    const user = this.getUserByIdUseCase.execute(id);

    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  }
}
