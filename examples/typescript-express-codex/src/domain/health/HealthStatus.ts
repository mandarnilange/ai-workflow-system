export type HealthStatusProps = {
  httpStatus: number;
  serverIp: string;
  message: string;
};

export class HealthStatus {
  private readonly httpStatus: number;
  private readonly serverIp: string;
  private readonly message: string;

  constructor(props: HealthStatusProps) {
    if (props.httpStatus < 100 || props.httpStatus > 599) {
      throw new Error('httpStatus must be a valid HTTP status code');
    }

    if (!props.serverIp) {
      throw new Error('serverIp is required');
    }

    if (!props.message) {
      throw new Error('message is required');
    }

    this.httpStatus = props.httpStatus;
    this.serverIp = props.serverIp;
    this.message = props.message;
  }

  toJSON() {
    return {
      httpStatus: this.httpStatus,
      serverIp: this.serverIp,
      message: this.message
    };
  }
}
