import 'package:dio/dio.dart';

import '../../core/errors/bank_error.dart';
import '../../core/network/dio_client.dart';
import '../../models/bill.dart';
import '../../models/biller.dart';
import '../../models/payment.dart';

class BillerRepository {
  final DioClient dioClient;

  BillerRepository({
    required this.dioClient,
  });

  Future<List<Biller>> getBillers({
    String? category,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/billers',
        queryParameters: {
          if (category != null) 'category': category,
        },
      );

      final data = response.data;

      return (data['billers'] as List)
          .map(
            (biller) => Biller.fromJson(
              biller as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message: error.message ?? 'Failed to load billers',
      );
    }
  }

  Future<void> saveBiller({
    required String billerId,
    required String nickname,
    required Map<String, String> accountDetails,
  }) async {
    try {
      await dioClient.dio.post(
        '/user-billers',
        data: {
          'billerId': billerId,
          'nickname': nickname,
          'accountDetails': accountDetails,
        },
      );
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message: error.message ?? 'Failed to save biller',
      );
    }
  }

  Future<List<UserBiller>> getSavedBillers() async {
    try {
      final response = await dioClient.dio.get(
        '/user-billers',
      );

      final data = response.data;

      return (data['billers'] as List)
          .map(
            (biller) => UserBiller.fromJson(
              biller as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message:
            error.message ?? 'Failed to load saved billers',
      );
    }
  }

  Future<List<Bill>> getBills() async {
    try {
      final response = await dioClient.dio.get(
        '/bills',
      );

      final data = response.data;

      return (data['bills'] as List)
          .map(
            (bill) => Bill.fromJson(
              bill as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message: error.message ?? 'Failed to load bills',
      );
    }
  }

  Future<Payment> payBill({
    required String billId,
    required double amount,
    required String idempotencyKey,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/payments',
        data: {
          'billId': billId,
          'amount': amount,
          'idempotencyKey': idempotencyKey,
        },
      );

      final data = response.data;

      return Payment.fromJson(
        data['payment'] as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      if (error.error is BankError) {
        throw error.error as BankError;
      }

      throw BankError(
        message: error.message ?? 'Payment failed',
      );
    }
  }
}

class UserBiller {
  final String id;
  final String billerId;
  final String billerName;
  final String category;
  final String nickname;
  final Map<String, dynamic> accountDetails;

  const UserBiller({
    required this.id,
    required this.billerId,
    required this.billerName,
    required this.category,
    required this.nickname,
    required this.accountDetails,
  });

  factory UserBiller.fromJson(Map<String, dynamic> json) {
    return UserBiller(
      id: json['_id'] as String,
      billerId: json['billerId'] as String,
      billerName: json['billerName'] as String,
      category: json['category'] as String,
      nickname: json['nickname'] as String,
      accountDetails: Map<String, dynamic>.from(
        json['accountDetails'] ?? {},
      ),
    );
  }
}