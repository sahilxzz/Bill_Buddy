import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/bank_error.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/biller_repository.dart';
import '../../models/bill.dart';
import '../auth/auth_state.dart';

class PaymentReviewScreen extends StatefulWidget {
  final Bill bill;
  final AuthState authState;

  const PaymentReviewScreen({
    super.key,
    required this.bill,
    required this.authState,
  });

  @override
  State<PaymentReviewScreen> createState() =>
      _PaymentReviewScreenState();
}

class _PaymentReviewScreenState
    extends State<PaymentReviewScreen> {
  late final BillerRepository billerRepository;

  bool isPaying = false;

  @override
  void initState() {
    super.initState();

    billerRepository = BillerRepository(
      dioClient: DioClient(
        authState: widget.authState,
      ),
    );
  }

  Future<void> _payBill() async {
    if (isPaying) {
      return;
    }

    setState(() {
      isPaying = true;
    });

    /*
     * A unique key for this payment attempt.
     *
     * If the same request gets retried with the same key,
     * the backend won't create a duplicate payment.
     */
    final idempotencyKey =
        '${widget.bill.id}-${DateTime.now().microsecondsSinceEpoch}';

    try {
      final payment = await billerRepository.payBill(
        billId: widget.bill.id,
        amount: widget.bill.amount,
        idempotencyKey: idempotencyKey,
      );

      if (!mounted) {
        return;
      }

      context.go(
        '/payment-success',
        extra: payment,
      );
    } on BankError catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );

      setState(() {
        isPaying = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment failed. Please try again.'),
        ),
      );

      setState(() {
        isPaying = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildRow(
                      'Biller',
                      widget.bill.billerName,
                    ),
                    _buildRow(
                      'Account',
                      widget.bill.nickname,
                    ),
                    _buildRow(
                      'Billing Period',
                      widget.bill.billingPeriod,
                    ),
                    _buildRow(
                      'Due Date',
                      _formatDate(widget.bill.dueDate),
                    ),
                    const Divider(height: 28),
                    _buildRow(
                      'Amount',
                      '₹${widget.bill.amount.toStringAsFixed(2)}',
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This is a demo payment. No real money will be charged.',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isPaying ? null : _payBill,
                child: isPaying
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Pay ₹${widget.bill.amount.toStringAsFixed(2)}',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}