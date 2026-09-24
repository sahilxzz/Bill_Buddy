class Bill {
  final String id;
  final String userBillerId;
  final String billerName;
  final String nickname;
  final String category;
  final Map<String, dynamic> accountDetails;
  final double amount;
  final DateTime dueDate;
  final String billingPeriod;
  final String status;

  const Bill({
    required this.id,
    required this.userBillerId,
    required this.billerName,
    required this.nickname,
    required this.category,
    required this.accountDetails,
    required this.amount,
    required this.dueDate,
    required this.billingPeriod,
    required this.status,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['_id'] as String,
      userBillerId: json['userBillerId'] as String,
      billerName: json['billerName'] as String,
      nickname: json['nickname'] as String,
      category: json['category'] as String,
      accountDetails: Map<String, dynamic>.from(
        json['accountDetails'] ?? {},
      ),
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      billingPeriod: json['billingPeriod'] as String,
      status: json['status'] as String,
    );
  }
}