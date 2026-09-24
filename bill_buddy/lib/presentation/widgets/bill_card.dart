import 'package:flutter/material.dart';

import '../../models/bill.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onTap;

  const BillCard({
    super.key,
    required this.bill,
    this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'electricity':
        return Icons.bolt;
      case 'water':
        return Icons.water_drop;
      case 'gas':
        return Icons.local_fire_department;
      case 'broadband':
        return Icons.wifi;
      case 'mobile':
        return Icons.phone_android;
      case 'dth':
        return Icons.tv;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.receipt_long;
    }
  }

  String _getStatusText() {
    switch (bill.status) {
      case 'overdue':
        return 'Overdue';
      case 'due_soon':
        return 'Due Soon';
      case 'paid':
        return 'Paid';
      default:
        return 'Upcoming';
    }
  }

  IconData _getStatusIcon() {
    switch (bill.status) {
      case 'overdue':
        return Icons.warning_amber_rounded;
      case 'due_soon':
        return Icons.schedule;
      case 'paid':
        return Icons.check_circle;
      default:
        return Icons.calendar_today;
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Icon(
                  _getCategoryIcon(bill.category),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.nickname,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      bill.billerName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(),
                          size: 16,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          _getStatusText(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          _formatDate(bill.dueDate),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${bill.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Icon(
                    Icons.chevron_right,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}