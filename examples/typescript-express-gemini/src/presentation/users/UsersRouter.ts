import { Router } from 'express';
import { UsersController } from './UsersController';

export class UsersRouter {
  constructor(private usersController: UsersController) {}

  getRouter(): Router {
    const router = Router();
    router.get('/users', (req, res) => this.usersController.getUsers(req, res));
    router.get('/users/:id', (req, res) => this.usersController.getUserById(req, res));
    return router;
  }
}
