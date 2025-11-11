export type UserRole = 'admin' | 'member';

export type UserProps = {
  id: string;
  name: string;
  email: string;
  role: UserRole;
};

export class User {
  private readonly id: string;
  private readonly name: string;
  private readonly email: string;
  private readonly role: UserRole;

  constructor(props: UserProps) {
    this.assertRequired(props.id, 'id');
    this.assertRequired(props.name, 'name');
    this.assertRequired(props.email, 'email');
    this.assertValidEmail(props.email);
    this.assertValidRole(props.role);

    this.id = props.id;
    this.name = props.name;
    this.email = props.email;
    this.role = props.role;
  }

  toJSON(): UserProps {
    return {
      id: this.id,
      name: this.name,
      email: this.email,
      role: this.role
    };
  }

  private assertRequired(value: string, field: keyof UserProps) {
    if (!value) {
      throw new Error(`${field} is required`);
    }
  }

  private assertValidEmail(email: string) {
    if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
      throw new Error('email must be valid');
    }
  }

  private assertValidRole(role: string) {
    if (role !== 'admin' && role !== 'member') {
      throw new Error('role must be a supported value');
    }
  }
}
