import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_state.dart';

import '../../core/errors/bank_error.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/biller_repository.dart';
import '../../models/bill.dart';
import '../../presentation/widgets/bill_card.dart';

class HomeScreen extends StatefulWidget {
  final AuthState authState;

  const HomeScreen({
    super.key,
    required this.authState,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthRepository authRepository;
  late final BillerRepository billerRepository;

  List<UserBiller> savedBillers = [];
  List<Bill> bills = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    final dioClient = DioClient(
      authState: widget.authState,
    );

    authRepository = AuthRepository(
      dioClient: dioClient,
      authState: widget.authState,
    );

    billerRepository = BillerRepository(
      dioClient: dioClient,
    );

    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        billerRepository.getSavedBillers(),
        billerRepository.getBills(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        savedBillers = results[0] as List<UserBiller>;
        bills = results[1] as List<Bill>;
        isLoading = false;
      });
    } on BankError catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = error.message;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = 'Failed to load your bills';
        isLoading = false;
      });
    }
  }

  Future<void> _testJwt() async {
    try {
      final user = await authRepository.getCurrentUser();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'JWT verified! Hello ${user.name}',
          ),
        ),
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
    }
  }

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

  String _getCategoryName(String category) {
    switch (category) {
      case 'electricity':
        return 'Electricity';
      case 'water':
        return 'Water';
      case 'gas':
        return 'Gas';
      case 'broadband':
        return 'Broadband';
      case 'mobile':
        return 'Mobile';
      case 'dth':
        return 'DTH';
      case 'credit_card':
        return 'Credit Card';
      default:
        return category;
    }
  }

  Widget _buildBillerCard(UserBiller biller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(
                _getCategoryIcon(biller.category),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    biller.nickname,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    biller.billerName,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _getCategoryName(biller.category),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBills() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 50,
            ),
            SizedBox(height: 12),
            Text(
              'No pending bills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'You are all caught up!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBillers() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 45,
            ),
            SizedBox(height: 10),
            Text(
              'No saved billers',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Add a biller to get started.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHomeData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCard(Bill bill) {
    return BillCard(
      bill: bill,
      onTap: () {
        context.push(
          '/payment-review',
          extra: bill,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Buddy'),
        actions: [
          IconButton(
            onPressed: () {
              widget.authState.logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _loadHomeData,
                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${widget.authState.name ?? 'there'} 👋',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Here is your bill overview',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Pending',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  '₹${_calculateTotal().toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '${bills.where((bill) => bill.status != 'paid').length} bills pending',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
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

                        if (bills
                            .where(
                              (bill) => bill.status != 'paid',
                            )
                            .isEmpty)
                          _buildEmptyBills()
                        else
                          ...bills
                              .where(
                                (bill) => bill.status != 'paid',
                              )
                              .map(
                                (bill) =>
                                    _buildBillCard(bill),
                              ),

                        const SizedBox(height: 16),

                        const Text(
                          'My Billers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (savedBillers.isEmpty)
                          _buildEmptyBillers()
                        else
                          ...savedBillers.map(
                            (biller) =>
                                _buildBillerCard(biller),
                          ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await context.push(
                                '/add-biller',
                              );

                              if (mounted) {
                                _loadHomeData();
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Biller'),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _testJwt,
                            child: const Text('Test JWT'),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }

  double _calculateTotal() {
    return bills
        .where(
          (bill) => bill.status != 'paid',
        )
        .fold(
          0,
          (total, bill) => total + bill.amount,
        );
  }
}