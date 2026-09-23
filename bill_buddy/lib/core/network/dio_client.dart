import 'package:dio/dio.dart';

import '../errors/bank_error.dart';
import '../../config/api_config.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final bankError = _mapError(error);

          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: bankError,
              message: bankError.message,
            ),
          );
        },
      ),
    );
  }

  BankError _mapError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return const BankError(
          message: 'Bad request',
          statusCode: 400,
        );

      case 401:
        return const BankError(
          message: 'Unauthorized',
          statusCode: 401,
        );

      case 403:
        return const BankError(
          message: 'Access denied',
          statusCode: 403,
        );

      case 404:
        return const BankError(
          message: 'Resource not found',
          statusCode: 404,
        );

      case 408:
        return const BankError(
          message: 'Request timed out',
          statusCode: 408,
        );

      case 409:
        return const BankError(
          message: 'Conflict',
          statusCode: 409,
        );

      case 429:
        return const BankError(
          message: 'Too many requests',
          statusCode: 429,
        );

      case 500:
        return const BankError(
          message: 'Server error',
          statusCode: 500,
        );

      case 502:
        return const BankError(
          message: 'Bad gateway',
          statusCode: 502,
        );

      case 503:
        return const BankError(
          message: 'Service unavailable',
          statusCode: 503,
        );

      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          return const BankError(
            message: 'Connection timed out',
          );
        }

        if (error.type == DioExceptionType.connectionError) {
          return const BankError(
            message: 'Unable to connect to the server',
          );
        }

        return BankError(
          message: error.message ?? 'Something went wrong',
          statusCode: statusCode,
        );
    }
  }
}