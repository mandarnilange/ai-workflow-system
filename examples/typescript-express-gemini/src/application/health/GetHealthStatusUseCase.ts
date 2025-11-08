import { HealthResponse } from '../../domain/health/HealthResponse';

export class GetHealthStatusUseCase {
  private timestampProvider: () => string;

  constructor(timestampProvider?: () => string) {
    this.timestampProvider = timestampProvider || (() => new Date().toISOString());
  }

  execute(): HealthResponse {
    return {
      status: 200,
      timestamp: this.timestampProvider(),
      message: 'OK',
    };
  }
}
