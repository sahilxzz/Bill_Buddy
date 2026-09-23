import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddBillerScreen extends StatelessWidget {
  const AddBillerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Biller'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add a bill',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Choose a category',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 105,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryItem(
                    icon: Icons.bolt,
                    title: 'Electricity',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=Electricity',
                      );
                    },
                  ),

                  _CategoryItem(
                    icon: Icons.water_drop,
                    title: 'Water',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=Water',
                      );
                    },
                  ),

                  _CategoryItem(
                    icon: Icons.local_fire_department,
                    title: 'Gas',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=Gas',
                      );
                    },
                  ),

                  _CategoryItem(
                    icon: Icons.wifi,
                    title: 'Broadband',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=Broadband',
                      );
                    },
                  ),

                  _CategoryItem(
                    icon: Icons.phone_android,
                    title: 'Mobile',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=Mobile',
                      );
                    },
                  ),

                  _CategoryItem(
                    icon: Icons.tv,
                    title: 'DTH',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=DTH',
                      );
                    },
                  ),

                  _CategoryItem(
                    icon: Icons.credit_card,
                    title: 'Credit Card',
                    onTap: () {
                      context.push(
                        '/biller-selection?category=Credit Card',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Your billers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your saved billers will appear here.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'No billers added yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 18),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}