import 'package:flutter/material.dart';
import '../../models/bill.dart';

class BillCard extends StatelessWidget {
  final Bill bill;

  const BillCard({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              bill.icon,
              size: 32,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.category,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(bill.biller),

                  const SizedBox(height: 4),

                  Text(bill.due),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  bill.amount,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Paying ${bill.biller}'),
                        ),
                    );
                  },
                  child: const Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}