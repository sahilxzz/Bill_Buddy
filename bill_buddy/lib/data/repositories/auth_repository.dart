import 'package:dio/dio.dart';

import '../../core/errors/bank_error.dart';
import '../../core/network/dio_client.dart';

class AuthResult {
  final String token;
  final String userId;
  final String name;
  final String email;

  const AuthResult({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
  });
}

class AuthRepository {
  final DioClient dioClient;

  AuthRepository({
    required this.dioClient,
  });

  Future<AuthResult> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/signup',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      return AuthResult(
        token: data['token'],
        userId: data['user']['id'],
        name: data['user']['name'],
        email: data['user']['email'],
      );
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message: error.message ?? 'Signup failed',
      );
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      return AuthResult(
        token: data['token'],
        userId: data['user']['id'],
        name: data['user']['name'],
        email: data['user']['email'],
      );
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message: error.message ?? 'Login failed',
      );
    }
  }
}