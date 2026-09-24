class BankError implements Exception {
  final String message;
  final int? statusCode;

  const BankError({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() {
    return message;
  }
}