export interface SystemInfoGateway {
  getServerIp(): Promise<string>;
}
