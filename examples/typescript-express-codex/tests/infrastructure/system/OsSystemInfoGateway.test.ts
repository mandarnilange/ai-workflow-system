import os from 'os';
import { OsSystemInfoGateway } from '../../../src/infrastructure/system/OsSystemInfoGateway';

describe('OsSystemInfoGateway', () => {
  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('should return first non-internal IPv4', async () => {
    jest.spyOn(os, 'networkInterfaces').mockReturnValue({
      lo: [{ address: '127.0.0.1', internal: true, family: 'IPv4' } as os.NetworkInterfaceInfo],
      eth0: [
        { address: 'fe80::1', internal: false, family: 'IPv6' } as os.NetworkInterfaceInfo,
        { address: '172.16.0.10', internal: false, family: 'IPv4' } as os.NetworkInterfaceInfo
      ]
    });

    const gateway = new OsSystemInfoGateway();
    await expect(gateway.getServerIp()).resolves.toBe('172.16.0.10');
  });

  it('should fall back to loopback when no interfaces available', async () => {
    jest.spyOn(os, 'networkInterfaces').mockReturnValue({});

    const gateway = new OsSystemInfoGateway();

    await expect(gateway.getServerIp()).resolves.toBe('127.0.0.1');
  });

  it('should skip undefined interface definitions', async () => {
    jest.spyOn(os, 'networkInterfaces').mockReturnValue({
      eth0: undefined
    } as unknown as NodeJS.Dict<os.NetworkInterfaceInfo[]>);

    const gateway = new OsSystemInfoGateway();

    await expect(gateway.getServerIp()).resolves.toBe('127.0.0.1');
  });
});
