import 'package:flutter/material.dart';

import '../../core/errors/bank_error.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/biller_repository.dart';
import '../../features/auth/auth_state.dart';
import '../../models/biller.dart';

class BillerFormScreen extends StatefulWidget {
  final String category;
  final String biller;
  final AuthState authState;

  const BillerFormScreen({
    super.key,
    required this.category,
    required this.biller,
    required this.authState,
  });

  @override
  State<BillerFormScreen> createState() => _BillerFormScreenState();
}

class _BillerFormScreenState extends State<BillerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final BillerRepository billerRepository;

  Biller? selectedBiller;

  bool isLoading = true;
  bool isSaving = false;

  String? errorMessage;

  final TextEditingController nicknameController =
      TextEditingController();

  final Map<String, TextEditingController> fieldControllers = {};

  @override
  void initState() {
    super.initState();

    billerRepository = BillerRepository(
      dioClient: DioClient(
        authState: widget.authState,
      ),
    );

    _loadBiller();
  }

  Future<void> _loadBiller() async {
    try {
      final backendCategory =
          widget.category.toLowerCase().replaceAll(' ', '_');

      final billers = await billerRepository.getBillers(
        category: backendCategory,
      );

      Biller? foundBiller;

      for (final biller in billers) {
        if (biller.name == widget.biller) {
          foundBiller = biller;
          break;
        }
      }

      if (foundBiller == null) {
        throw const BankError(
          message: 'Selected biller was not found',
        );
      }

      for (final field in foundBiller.fields) {
        fieldControllers[field.key] =
            TextEditingController();
      }

      if (!mounted) return;

      setState(() {
        selectedBiller = foundBiller;
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
        errorMessage = 'Failed to load biller details';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nicknameController.dispose();

    for (final controller in fieldControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedBiller == null) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final accountDetails = <String, String>{};

    for (final field in selectedBiller!.fields) {
      accountDetails[field.key] =
          fieldControllers[field.key]!.text.trim();
    }

    try {
      await billerRepository.saveBiller(
        billerId: selectedBiller!.id,
        nickname: nicknameController.text.trim(),
        accountDetails: accountDetails,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biller saved successfully'),
        ),
      );

      Navigator.of(context).pop();
    } on BankError catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String? _validateField(
    String? value,
    BillerField field,
  ) {
    final text = value?.trim() ?? '';

    if (field.required && text.isEmpty) {
      return 'Please enter ${field.label.toLowerCase()}';
    }

    if (text.isEmpty) {
      return null;
    }

    if (field.type == 'number' &&
        int.tryParse(text) == null) {
      return '${field.label} must contain only numbers';
    }

    if (field.minLength != null &&
        text.length < field.minLength!) {
      return '${field.label} must be at least ${field.minLength} characters';
    }

    if (field.maxLength != null &&
        text.length > field.maxLength!) {
      return '${field.label} must be at most ${field.maxLength} characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.biller}'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
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

                  _loadBiller();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final biller = selectedBiller!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              biller.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.category,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Bill details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            ...biller.fields.map(
              (field) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: fieldControllers[field.key],
                  keyboardType: field.type == 'number'
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: field.label,
                    hintText:
                        'Enter your ${field.label.toLowerCase()}',
                    prefixIcon: const Icon(
                      Icons.receipt_long,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    return _validateField(value, field);
                  },
                ),
              ),
            ),

            TextFormField(
              controller: nicknameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nickname',
                hintText: 'e.g. Home Electricity',
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a nickname';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            Text(
              'You can use a nickname to easily identify this biller later.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : _continue,
                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}