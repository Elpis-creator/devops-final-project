
const request = require('supertest');
const app = require('./index');

describe('DevOps Deployment Dashboard', () => {
  test('GET / returns the dashboard page', async () => {
    const response = await request(app).get('/');

    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('DevOps Deployment Dashboard');
  });

  test('GET /api/status returns application status', async () => {
    const response = await request(app).get('/api/status');

    expect(response.statusCode).toBe(200);
    expect(response.body.application).toBe('DevOps Deployment Dashboard');
    expect(response.body.status).toBe('running');
    expect(['connected', 'disconnected']).toContain(response.body.database);
    expect(response.body).toHaveProperty('version');
    expect(response.body).toHaveProperty('timestamp');
  });
});
