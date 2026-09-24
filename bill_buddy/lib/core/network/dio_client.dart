import 'package:dio/dio.dart';

import '../../config/api_config.dart';
import '../../features/auth/auth_state.dart';
import '../errors/bank_error.dart';

class DioClient {
  late final Dio dio;

  final AuthState authState;

  DioClient({
    required this.authState,
  }) {
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
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = authState.token;

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

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
    final responseData = error.response?.data;

    String? serverMessage;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];

      if (message is String && message.isNotEmpty) {
        serverMessage = message;
      }
    }

    if (serverMessage != null) {
      return BankError(
        message: serverMessage,
        statusCode: statusCode,
      );
    }

    switch (statusCode) {
      case 400:
        return const BankError(
          message: 'Invalid request',
          statusCode: 400,
        );

      case 401:
        return const BankError(
          message: 'Invalid or expired token',
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
          message: 'This already exists',
          statusCode: 409,
        );

      case 429:
        return const BankError(
          message: 'Too many requests. Please try again later.',
          statusCode: 429,
        );

      case 500:
        return const BankError(
          message: 'Something went wrong on the server',
          statusCode: 500,
        );

      case 502:
        return const BankError(
          message: 'Bad gateway',
          statusCode: 502,
        );

      case 503:
        return const BankError(
          message: 'Service temporarily unavailable',
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