import { User, UserProps } from '../../../src/domain/users/User';

describe('User', () => {
  const validProps: UserProps = {
    id: 'user-1',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    role: 'member'
  };

  it('should expose an immutable JSON representation', () => {
    const user = new User(validProps);

    expect(user.toJSON()).toEqual(validProps);
  });

  it.each([
    ['id', { ...validProps, id: '' }],
    ['name', { ...validProps, name: '' }],
    ['email', { ...validProps, email: '' }]
  ])('should throw when %s is missing', (_field, props) => {
    expect(() => new User(props as UserProps)).toThrowError();
  });

  it('should validate email format', () => {
    expect(() => new User({ ...validProps, email: 'not-an-email' })).toThrowError(
      /email/i
    );
  });

  it('should restrict role to supported values', () => {
    expect(() =>
      new User({ ...validProps, role: 'invalid' as unknown as UserProps['role'] })
    ).toThrowError(/role/i);
  });
});
