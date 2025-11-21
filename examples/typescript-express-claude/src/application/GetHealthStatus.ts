export interface HealthStatus {
  status: string;
  message: string;
  timestamp: Date;
}

export class GetHealthStatus {
  execute(): HealthStatus {
    return {
      status: 'ok',
      message: 'Service is healthy',
      timestamp: new Date()
    };
  }
}
