import { EventEmitter } from 'events';
import os from 'os';
import { createRequest, createResponse } from 'node-mocks-http';
import { buildApp } from '../../src/presentation/server';

describe('server bootstrap', () => {
  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('should use default container when none provided', async () => {
    jest.spyOn(os, 'networkInterfaces').mockReturnValue({
      lo: [{ address: '127.0.0.1', internal: true, family: 'IPv4' } as os.NetworkInterfaceInfo],
      eth0: [{ address: '10.1.1.5', internal: false, family: 'IPv4' } as os.NetworkInterfaceInfo]
    });

    const app = buildApp();

    const req = createRequest({
      method: 'GET',
      url: '/health'
    });

    const res = createResponse({
      eventEmitter: EventEmitter
    });

    const finished = new Promise<void>((resolve, reject) => {
      const done = () => resolve();
      res.on('end', done);
      res.on('finish', done);
      res.on('error', reject);
    });

    app(req, res);
    await finished;

    expect(res.statusCode).toBe(200);
    expect(res._getJSONData()).toEqual({
      httpStatus: 200,
      serverIp: '10.1.1.5',
      message: 'Service is healthy'
    });
  });
});
