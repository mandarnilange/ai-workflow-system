import { GetHealthStatusUseCase } from '../../../src/application/health/GetHealthStatusUseCase';
import { HealthResponse } from '../../../src/domain/health/HealthResponse';

const realDate = Date; // Store original Date

describe('GetHealthStatusUseCase', () => {
  afterEach(() => {
    // Restore original Date object
    Object.defineProperty(global, 'Date', {
      value: realDate,
      writable: true,
    });
  });

  it('should return health status with provided timestamp', () => {
    const mockTimestamp = '2025-11-08T12:00:00.000Z';
    const useCase = new GetHealthStatusUseCase(() => mockTimestamp);
    const expectedResponse: HealthResponse = {
      status: 200,
      timestamp: mockTimestamp,
      message: 'OK',
    };

    const result = useCase.execute();
    expect(result).toEqual(expectedResponse);
  });

  it('should return health status with current timestamp when no provider is given', () => {
    const mockDate = new Date('2025-11-08T12:00:00.000Z');
    const mockDateISOString = mockDate.toISOString();

    // Mock the global Date object
    const mockDateConstructor = jest.fn(() => mockDate) as unknown as jest.MockedFunction<typeof Date>;
    mockDateConstructor.now = jest.fn(() => mockDate.getTime());
    Object.defineProperty(global, 'Date', {
      value: mockDateConstructor,
      writable: true,
    });

    const useCase = new GetHealthStatusUseCase();
    const expectedResponse: HealthResponse = {
      status: 200,
      timestamp: mockDateISOString,
      message: 'OK',
    };

    const result = useCase.execute();
    expect(result).toEqual(expectedResponse);
  });
});
