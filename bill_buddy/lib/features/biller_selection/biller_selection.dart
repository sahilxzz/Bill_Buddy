import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BillerSelectionScreen extends StatelessWidget {
  final String category;

  const BillerSelectionScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final billers = _getBillers(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your biller',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Select the biller you want to add.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search biller',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Available billers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: billers.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  final biller = billers[index];

                  return _BillerTile(
                    name: biller['name']!,
                    description: biller['description']!,
                    onTap: () {
                      context.push(
                        '/biller-form'
                        '?category=${Uri.encodeComponent(category)}'
                        '&biller=${Uri.encodeComponent(biller['name']!)}',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getBillers(String category) {
    switch (category) {
      case 'Electricity':
        return [
          {
            'name': 'BESCOM',
            'description':
                'Bangalore Electricity Supply Company',
          },
          {
            'name': 'Tata Power',
            'description': 'Electricity bill payment',
          },
          {
            'name': 'Adani Electricity',
            'description': 'Electricity bill payment',
          },
        ];

      case 'Water':
        return [
          {
            'name': 'Bangalore Water Supply',
            'description': 'Water bill payment',
          },
          {
            'name': 'Delhi Jal Board',
            'description': 'Water bill payment',
          },
        ];

      case 'Gas':
        return [
          {
            'name': 'Indraprastha Gas',
            'description': 'Piped gas bill payment',
          },
          {
            'name': 'Mahanagar Gas',
            'description': 'Piped gas bill payment',
          },
        ];

      case 'Broadband':
        return [
          {
            'name': 'Airtel Xstream Fiber',
            'description': 'Broadband bill payment',
          },
          {
            'name': 'JioFiber',
            'description': 'Broadband bill payment',
          },
        ];

      case 'Mobile':
        return [
          {
            'name': 'Airtel',
            'description': 'Mobile postpaid bill',
          },
          {
            'name': 'Jio',
            'description': 'Mobile postpaid bill',
          },
          {
            'name': 'Vi',
            'description': 'Mobile postpaid bill',
          },
        ];

      case 'DTH':
        return [
          {
            'name': 'Tata Play',
            'description': 'DTH bill payment',
          },
          {
            'name': 'Airtel Digital TV',
            'description': 'DTH bill payment',
          },
        ];

      case 'Credit Card':
        return [
          {
            'name': 'ICICI Bank',
            'description': 'Credit card bill payment',
          },
          {
            'name': 'HDFC Bank',
            'description': 'Credit card bill payment',
          },
        ];

      default:
        return [];
    }
  }
}

class _BillerTile extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const _BillerTile({
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business,
                  size: 22,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}