import request from 'supertest';
import { createApp } from '../../src/presentation/app';

describe('GET /api/users', () => {
  it('should return 200 OK with users array', async () => {
    // Arrange
    const app = createApp();

    // Act
    const response = await request(app).get('/api/users');

    // Assert
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body.length).toBeGreaterThanOrEqual(3);

    // Verify each user has required properties
    response.body.forEach((user: { id: string; name: string; email: string }) => {
      expect(user).toHaveProperty('id');
      expect(user).toHaveProperty('name');
      expect(user).toHaveProperty('email');
      expect(typeof user.id).toBe('string');
      expect(typeof user.name).toBe('string');
      expect(typeof user.email).toBe('string');
    });
  });
});
