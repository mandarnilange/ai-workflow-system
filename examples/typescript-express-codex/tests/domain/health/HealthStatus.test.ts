import { HealthStatus } from '../../../src/domain/health/HealthStatus';

describe('HealthStatus', () => {
  it('should expose http status, server IP, and message when serialized', () => {
    const status = new HealthStatus({
      httpStatus: 200,
      serverIp: '192.168.0.2',
      message: 'Service healthy'
    });

    expect(status.toJSON()).toEqual({
      httpStatus: 200,
      serverIp: '192.168.0.2',
      message: 'Service healthy'
    });
  });

  it('should throw when http status outside valid range', () => {
    expect(
      () =>
        new HealthStatus({
          httpStatus: 99,
          serverIp: '1.1.1.1',
          message: 'Invalid'
        })
    ).toThrow('httpStatus must be a valid HTTP status code');
  });

  it('should require server IP and message', () => {
    expect(
      () =>
        new HealthStatus({
          httpStatus: 200,
          serverIp: '',
          message: 'missing ip'
        })
    ).toThrow('serverIp is required');

    expect(
      () =>
        new HealthStatus({
          httpStatus: 200,
          serverIp: '1.1.1.1',
          message: ''
        })
    ).toThrow('message is required');
  });
});
