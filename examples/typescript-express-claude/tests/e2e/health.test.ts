import request from 'supertest';
import { createApp } from '../../src/presentation/app';

describe('GET /healthz', () => {
  it('should return 200 OK with health status', async () => {
    // Arrange
    const app = createApp();

    // Act
    const response = await request(app).get('/healthz');

    // Assert
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('status', 'ok');
    expect(response.body).toHaveProperty('message', 'Service is healthy');
    expect(response.body).toHaveProperty('timestamp');
    expect(new Date(response.body.timestamp)).toBeInstanceOf(Date);
  });
});
