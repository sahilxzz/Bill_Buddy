import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/bank_error.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/biller_repository.dart';
import '../../features/auth/auth_state.dart';
import '../../models/biller.dart';

class BillerSelectionScreen extends StatefulWidget {
  final String category;
  final AuthState authState;

  const BillerSelectionScreen({
    super.key,
    required this.category,
    required this.authState,
  });

  @override
  State<BillerSelectionScreen> createState() =>
      _BillerSelectionScreenState();
}

class _BillerSelectionScreenState
    extends State<BillerSelectionScreen> {
  late final BillerRepository billerRepository;

  List<Biller> billers = [];
  List<Biller> filteredBillers = [];

  bool isLoading = true;
  String? errorMessage;

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    billerRepository = BillerRepository(
      dioClient: DioClient(
        authState: widget.authState,
      ),
    );

    _loadBillers();

    searchController.addListener(_filterBillers);
  }

  Future<void> _loadBillers() async {
    try {
      final backendCategory =
          widget.category.toLowerCase().replaceAll(' ', '_');

      final result = await billerRepository.getBillers(
        category: backendCategory,
      );

      if (!mounted) return;

      setState(() {
        billers = result;
        filteredBillers = result;
        isLoading = false;
      });
    } on BankError catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.message;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load billers';
        isLoading = false;
      });
    }
  }

  void _filterBillers() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredBillers = billers;
      } else {
        filteredBillers = billers
            .where(
              (biller) =>
                  biller.name.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
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
              controller: searchController,
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
              child: _buildBillerList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillerList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),

            const SizedBox(height: 12),

            Text(
              errorMessage!,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                _loadBillers();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (filteredBillers.isEmpty) {
      return const Center(
        child: Text(
          'No billers found',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredBillers.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final biller = filteredBillers[index];

        return _BillerTile(
          name: biller.name,
          description: _getDescription(biller),
          onTap: () {
            context.push(
              '/biller-form'
              '?category=${Uri.encodeComponent(widget.category)}'
              '&biller=${Uri.encodeComponent(biller.name)}',
            );
          },
        );
      },
    );
  }

  String _getDescription(Biller biller) {
    switch (biller.category) {
      case 'electricity':
        return 'Electricity bill payment';

      case 'water':
        return 'Water bill payment';

      case 'gas':
        return 'Gas bill payment';

      case 'broadband':
        return 'Broadband bill payment';

      case 'mobile':
        return 'Mobile bill payment';

      case 'dth':
        return 'DTH bill payment';

      case 'credit_card':
        return 'Credit card bill payment';

      default:
        return 'Bill payment';
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