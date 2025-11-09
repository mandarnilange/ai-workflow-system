import os from 'os';
import { SystemInfoGateway } from '../../domain/health/SystemInfoGateway';

export class OsSystemInfoGateway implements SystemInfoGateway {
  getServerIp(): Promise<string> {
    const interfaces = os.networkInterfaces();

    for (const interfaceInfos of Object.values(interfaces)) {
      if (!interfaceInfos) {
        continue;
      }

      for (const info of interfaceInfos) {
        if (info.family === 'IPv4' && !info.internal && info.address) {
          return Promise.resolve(info.address);
        }
      }
    }

    return Promise.resolve('127.0.0.1');
  }
}
