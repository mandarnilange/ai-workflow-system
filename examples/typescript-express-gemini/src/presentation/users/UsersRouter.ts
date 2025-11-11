import { Router } from 'express';
import { UsersController } from './UsersController';

export class UsersRouter {
  constructor(private usersController: UsersController) {}

  getRouter(): Router {
    const router = Router();
    router.get('/users', (req, res) => this.usersController.getUsers(req, res));
    return router;
  }
}
