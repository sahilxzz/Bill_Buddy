import 'package:flutter/material.dart';

class BillerFormScreen extends StatefulWidget {
  final String category;
  final String biller;

  const BillerFormScreen({
    super.key,
    required this.category,
    required this.biller,
  });

  @override
  State<BillerFormScreen> createState() => _BillerFormScreenState();
}

class _BillerFormScreenState extends State<BillerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController consumerNumberController =
      TextEditingController();

  final TextEditingController nicknameController =
      TextEditingController();

  @override
  void dispose() {
    consumerNumberController.dispose();
    nicknameController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biller details are valid'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.biller}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.biller,
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

              TextFormField(
                controller: consumerNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Consumer Number',
                  hintText: 'Enter your consumer number',
                  prefixIcon: const Icon(Icons.receipt_long),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your consumer number';
                  }

                  if (value.length < 6) {
                    return 'Consumer number is too short';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

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
                  onPressed: _continue,
                  child: const Text(
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
      ),
    );
  }
}