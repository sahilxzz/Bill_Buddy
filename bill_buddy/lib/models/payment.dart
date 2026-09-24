class Payment {
  final String id;
  final String billId;
  final double amount;
  final String status;
  final String transactionId;
  final DateTime paidAt;

  const Payment({
    required this.id,
    required this.billId,
    required this.amount,
    required this.status,
    required this.transactionId,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'] as String,
      billId: json['billId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      transactionId: json['transactionId'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
    );
  }
}