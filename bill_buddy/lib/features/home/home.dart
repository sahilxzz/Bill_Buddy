import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/bill.dart';
import '../../presentation/widgets/bill_card.dart';
import '../auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  final AuthState authState;

  const HomeScreen({
    super.key,
    required this.authState,
  });

  @override
  Widget build(BuildContext context) {
    final bills = [
      const Bill(
        icon: Icons.bolt,
        category: 'Electricity',
        biller: 'BESCOM',
        amount: '₹1,240',
        due: 'Due tomorrow',
      ),
      const Bill(
        icon: Icons.phone_android,
        category: 'Mobile',
        biller: 'Airtel',
        amount: '₹599',
        due: 'Due in 5 days',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Buddy'),
        actions: [
          IconButton(
            onPressed: () {
              authState.logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Here are your upcoming bills',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Upcoming Bills',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (bills.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 50,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'You’re all caught up!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'You don’t have any upcoming bills.',
                      ),
                    ],
                  ),
                ),
              )
            else
              ...bills.map(
                (bill) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BillCard(
                    bill: bill,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/add-biller');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Biller'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}